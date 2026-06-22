import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';

enum SensorMode { connect, measure }

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key, this.mode = SensorMode.connect});

  final SensorMode mode;

  @override
  Widget build(BuildContext context) {
    final isConnect = mode == SensorMode.connect;

    return Scaffold(
      appBar: AppBar(
        title: Text(isConnect ? 'Connect Sensor' : 'Live Measurement'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  isConnect ? Icons.bluetooth_searching : Icons.sensors_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                isConnect ? 'BLE Sensor Pairing' : 'Live Soil Reading',
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isConnect
                    ? 'Bluetooth Low Energy module will be implemented in a future phase. Your ESP32 sensor will appear here.'
                    : 'Live measurement stream from the 7-in-1 soil sensor will be available once BLE is implemented.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
