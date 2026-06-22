import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import 'status_chip.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final LinearGradient? iconGradient;
  final StatusLevel? statusLevel;
  final String? statusLabel;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    this.iconGradient,
    this.statusLevel,
    this.statusLabel,
    this.onTap,
    this.trailing,
  });

  // Named constructors for the 7 soil sensor readings
  factory StatCard.nitrogen({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Nitrogen (N)',
        value: value,
        unit: 'mg/kg',
        icon: Icons.science_outlined,
        iconGradient: AppGradients.nitrogen,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.phosphorus({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Phosphorus (P)',
        value: value,
        unit: 'mg/kg',
        icon: Icons.bubble_chart_outlined,
        iconGradient: AppGradients.phosphorus,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.potassium({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Potassium (K)',
        value: value,
        unit: 'mg/kg',
        icon: Icons.grain_outlined,
        iconGradient: AppGradients.potassium,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.ph({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'pH Level',
        value: value,
        icon: Icons.water_drop_outlined,
        iconGradient: AppGradients.ph,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.moisture({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Moisture',
        value: value,
        unit: '%',
        icon: Icons.opacity_outlined,
        iconGradient: AppGradients.moisture,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.temperature({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Temperature',
        value: value,
        unit: '°C',
        icon: Icons.thermostat_outlined,
        iconGradient: AppGradients.temperature,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  factory StatCard.conductivity({
    required String value,
    String? statusLabel,
    StatusLevel? statusLevel,
    VoidCallback? onTap,
  }) =>
      StatCard(
        label: 'Conductivity',
        value: value,
        unit: 'µS/cm',
        icon: Icons.electric_bolt_outlined,
        iconGradient: AppGradients.conductivity,
        statusLevel: statusLevel,
        statusLabel: statusLabel,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: iconGradient ?? AppGradients.primaryButton,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.white, size: 22),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTypography.numericMedium),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      unit!,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.bodySmall),
            if (statusLevel != null && statusLabel != null) ...[
              const SizedBox(height: 10),
              StatusChip(label: statusLabel!, level: statusLevel!),
            ],
          ],
        ),
      ),
    );
  }
}
