/*
 * ============================================================================
 *  Smart Soil Management - ESP32 RS485 7-in-1 Soil Sensor + BLE Server
 * ============================================================================
 *
 *  Board        : ESP32 Dev Module
 *  Arduino Core : 2.0.18
 *  Sensor       : 7-in-1 RS485 Soil Sensor (Modbus RTU)
 *  Transceiver  : MAX485
 *  Libraries    : ModbusMaster, BLEDevice (bundled with ESP32 core)
 *
 *  Wiring
 *  ------
 *    MAX485 RO  -> ESP32 GPIO16 (RXD2)
 *    MAX485 DI  -> ESP32 GPIO17 (TXD2)
 *    MAX485 DE  -> ESP32 GPIO4  (DE_RE)
 *    MAX485 RE  -> ESP32 GPIO4  (DE_RE)  (DE and RE tied together)
 *    MAX485 A/B -> Sensor A/B
 *    Sensor VCC -> 9-24V supply   |   Common GND with ESP32
 *
 *  Modbus configuration (unchanged)
 *  --------------------------------
 *    Slave address          : 1
 *    Baud rate              : 9600 (8N1)
 *    Function               : Read Holding Registers (0x03)
 *    Start register         : 0x0000
 *    Quantity               : 7
 *
 *  Register map (0x0000 .. 0x0006)
 *  -------------------------------
 *    [0] Moisture     (x10, %)
 *    [1] Temperature  (x10, degC, signed)
 *    [2] EC           (uS/cm  -> mS/cm)
 *    [3] pH           (x10)
 *    [4] Nitrogen     (mg/kg)
 *    [5] Phosphorus   (mg/kg)
 *    [6] Potassium    (mg/kg)
 *
 *  BLE output
 *  ----------
 *    Every successful reading is transmitted (Notify) as one CSV line:
 *      Nitrogen,Phosphorus,Potassium,pH,Moisture,Temperature,EC
 *    Example:
 *      45,21,95,6.4,38.5,27.8,1.12
 * ============================================================================
 */

#include <Arduino.h>
#include <ModbusMaster.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// ----------------------------------------------------------------------------
//  Hardware / Modbus configuration
// ----------------------------------------------------------------------------
#define RXD2            16          // MAX485 RO  -> ESP32 RX
#define TXD2            17          // MAX485 DI  -> ESP32 TX
#define DE_RE_PIN       4           // MAX485 DE + RE control
#define MODBUS_SLAVE_ID 1           // Sensor Modbus slave address
#define MODBUS_BAUD     9600        // Sensor baud rate
#define REG_START       0x0000      // First holding register
#define REG_QTY         7           // Number of registers to read

// Read cadence
#define READ_INTERVAL_MS 2000UL     // Poll the sensor every 2 seconds

// ----------------------------------------------------------------------------
//  BLE configuration
// ----------------------------------------------------------------------------
#define BLE_DEVICE_NAME     "SoilSensor_ESP32"
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcdefab-1234-5678-1234-abcdefabcdef"

// ----------------------------------------------------------------------------
//  Globals
// ----------------------------------------------------------------------------
ModbusMaster node;                  // Modbus master instance (UNCHANGED)

BLEServer*         pServer         = nullptr;
BLECharacteristic* pCharacteristic = nullptr;

volatile bool deviceConnected    = false;   // Current BLE connection state
bool          oldDeviceConnected = false;   // Previous BLE connection state

unsigned long lastReadMs = 0;       // Timestamp of last sensor poll

// Latest parsed sensor values
struct SoilData {
  float    moisture;     // %
  float    temperature;  // degC
  float    ec;           // mS/cm
  float    ph;           // pH
  uint16_t nitrogen;     // mg/kg
  uint16_t phosphorus;   // mg/kg
  uint16_t potassium;    // mg/kg
};

// ----------------------------------------------------------------------------
//  MAX485 direction control callbacks for ModbusMaster
//  DE/RE HIGH = transmit, LOW = receive.
// ----------------------------------------------------------------------------
void preTransmission() {
  digitalWrite(DE_RE_PIN, HIGH);    // Enable driver (TX mode)
  delayMicroseconds(50);            // Allow line to settle
}

void postTransmission() {
  delayMicroseconds(50);            // Let last byte shift out
  digitalWrite(DE_RE_PIN, LOW);     // Enable receiver (RX mode)
}

// ----------------------------------------------------------------------------
//  BLE server connection callbacks
// ----------------------------------------------------------------------------
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* server) override {
    deviceConnected = true;
    Serial.println(F("[BLE] Client connected."));
  }

  void onDisconnect(BLEServer* server) override {
    deviceConnected = false;
    Serial.println(F("[BLE] Client disconnected."));
    // Advertising is restarted in loop() once the stack is ready.
  }
};

// ----------------------------------------------------------------------------
//  BLE initialisation
// ----------------------------------------------------------------------------
void initBLE() {
  Serial.println(F("[BLE] Initialising server..."));

  BLEDevice::init(BLE_DEVICE_NAME);

  // Create the BLE server and register connection callbacks.
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  // Create the BLE service.
  BLEService* pService = pServer->createService(SERVICE_UUID);

  // Create a Notify characteristic (read + notify).
  pCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ |
      BLECharacteristic::PROPERTY_NOTIFY);

  // Client Characteristic Configuration Descriptor (0x2902) for notifications.
  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setValue("0,0,0,0,0,0,0");

  // Start the service.
  pService->start();

  // Configure and start advertising.
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);   // iOS connection helper
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.println(F("[BLE] Advertising started. Waiting for a client..."));
}

// ----------------------------------------------------------------------------
//  Read the 7-in-1 sensor over Modbus.  Returns true on success.
//  NOTE: Modbus call, register addresses and parsing are intentionally
//        left unchanged from the existing implementation.
// ----------------------------------------------------------------------------
bool readSensor(SoilData& out) {
  uint8_t result = node.readHoldingRegisters(REG_START, REG_QTY);

  if (result != node.ku8MBSuccess) {
    Serial.print(F("[MODBUS] Read failed, error code: 0x"));
    Serial.println(result, HEX);
    return false;
  }

  // Raw 16-bit registers as returned by the sensor.
  uint16_t raw[REG_QTY];
  for (uint8_t i = 0; i < REG_QTY; i++) {
    raw[i] = node.getResponseBuffer(i);
  }

  // Parsing / scaling (unchanged).
  out.moisture    = raw[0] / 10.0f;            // %
  out.temperature = (int16_t)raw[1] / 10.0f;   // degC (signed)
  out.ec          = raw[2] / 1000.0f;          // uS/cm -> mS/cm
  out.ph          = raw[3] / 10.0f;            // pH
  out.nitrogen    = raw[4];                    // mg/kg
  out.phosphorus  = raw[5];                    // mg/kg
  out.potassium   = raw[6];                    // mg/kg

  return true;
}

// ----------------------------------------------------------------------------
//  Build the CSV payload:
//    Nitrogen,Phosphorus,Potassium,pH,Moisture,Temperature,EC
// ----------------------------------------------------------------------------
void buildCsv(const SoilData& d, char* buf, size_t len) {
  snprintf(buf, len, "%u,%u,%u,%.1f,%.1f,%.1f,%.2f",
           d.nitrogen,
           d.phosphorus,
           d.potassium,
           d.ph,
           d.moisture,
           d.temperature,
           d.ec);
}

// ----------------------------------------------------------------------------
//  Setup
// ----------------------------------------------------------------------------
void setup() {
  // USB serial for debug logs.
  Serial.begin(115200);
  delay(200);
  Serial.println();
  Serial.println(F("============================================"));
  Serial.println(F(" ESP32 7-in-1 Soil Sensor - BLE Server"));
  Serial.println(F("============================================"));

  // MAX485 direction pin.
  pinMode(DE_RE_PIN, OUTPUT);
  digitalWrite(DE_RE_PIN, LOW);     // Start in receive mode.

  // RS485 UART on Serial2.
  Serial2.begin(MODBUS_BAUD, SERIAL_8N1, RXD2, TXD2);

  // Modbus master setup (UNCHANGED).
  node.begin(MODBUS_SLAVE_ID, Serial2);
  node.preTransmission(preTransmission);
  node.postTransmission(postTransmission);

  Serial.println(F("[MODBUS] Master ready (Slave 1, 9600 8N1)."));

  // Bring up the BLE server.
  initBLE();
}

// ----------------------------------------------------------------------------
//  Main loop
// ----------------------------------------------------------------------------
void loop() {
  // ----- Handle BLE (re)connection / advertising -----
  // Client just disconnected -> restart advertising so it can reconnect.
  if (!deviceConnected && oldDeviceConnected) {
    delay(500);                      // Give the BLE stack time to settle.
    pServer->startAdvertising();
    Serial.println(F("[BLE] Restarting advertising after disconnect."));
    oldDeviceConnected = deviceConnected;
  }

  // Client just connected -> sync state.
  if (deviceConnected && !oldDeviceConnected) {
    oldDeviceConnected = deviceConnected;
    Serial.println(F("[BLE] Connection established."));
  }

  // ----- Poll the sensor on a fixed interval -----
  unsigned long now = millis();
  if (now - lastReadMs >= READ_INTERVAL_MS) {
    lastReadMs = now;

    SoilData data;
    if (readSensor(data)) {
      char csv[64];
      buildCsv(data, csv, sizeof(csv));

      // Serial debug log of the reading.
      Serial.print(F("[DATA] "));
      Serial.println(csv);

      // Notify only when a client is connected.
      if (deviceConnected && pCharacteristic != nullptr) {
        pCharacteristic->setValue((uint8_t*)csv, strlen(csv));
        pCharacteristic->notify();
        Serial.println(F("[BLE] Notification sent."));
      } else {
        Serial.println(F("[BLE] No client connected - notify skipped."));
      }
    }
    // On a failed read, readSensor() already logged the error code.
  }

  delay(10);   // Small yield to keep the BLE stack responsive.
}
