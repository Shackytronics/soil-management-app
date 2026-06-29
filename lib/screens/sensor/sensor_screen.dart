import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extension.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(isConnect
            ? l10n.sensorConnectTitle
            : l10n.sensorMeasureTitle),
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
                isConnect ? l10n.sensorPairingTitle : l10n.sensorLiveTitle,
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isConnect ? l10n.sensorConnectBody : l10n.sensorLiveBody,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.sensorGoBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
