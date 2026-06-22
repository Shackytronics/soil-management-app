// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementModelAdapter extends TypeAdapter<MeasurementModel> {
  @override
  final int typeId = 2;

  @override
  MeasurementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasurementModel(
      id: fields[0] as String,
      plotId: fields[1] as String,
      plotName: fields[2] as String,
      userId: fields[3] as String,
      nitrogen: fields[4] as double,
      phosphorus: fields[5] as double,
      potassium: fields[6] as double,
      ph: fields[7] as double,
      moisture: fields[8] as double,
      temperature: fields[9] as double,
      ec: fields[10] as double,
      recordedAt: fields[11] as DateTime,
      notes: fields[12] as String?,
      isSynced: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MeasurementModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plotId)
      ..writeByte(2)
      ..write(obj.plotName)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.nitrogen)
      ..writeByte(5)
      ..write(obj.phosphorus)
      ..writeByte(6)
      ..write(obj.potassium)
      ..writeByte(7)
      ..write(obj.ph)
      ..writeByte(8)
      ..write(obj.moisture)
      ..writeByte(9)
      ..write(obj.temperature)
      ..writeByte(10)
      ..write(obj.ec)
      ..writeByte(11)
      ..write(obj.recordedAt)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
