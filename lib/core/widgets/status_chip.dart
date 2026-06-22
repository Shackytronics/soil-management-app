import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum StatusLevel { success, warning, danger, info, neutral }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusLevel level;
  final bool showDot;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    this.level = StatusLevel.neutral,
    this.showDot = true,
    this.icon,
  });

  /// Convenience constructors for common soil-health states
  const StatusChip.good({super.key, required this.label})
      : level = StatusLevel.success,
        showDot = true,
        icon = null;

  const StatusChip.low({super.key, required this.label})
      : level = StatusLevel.warning,
        showDot = true,
        icon = null;

  const StatusChip.critical({super.key, required this.label})
      : level = StatusLevel.danger,
        showDot = true,
        icon = null;

  const StatusChip.synced({super.key, required this.label})
      : level = StatusLevel.info,
        showDot = false,
        icon = Icons.cloud_done_outlined;

  const StatusChip.offline({super.key, required this.label})
      : level = StatusLevel.neutral,
        showDot = false,
        icon = Icons.cloud_off_outlined;

  Color get _backgroundColor => switch (level) {
        StatusLevel.success => AppColors.successLight,
        StatusLevel.warning => AppColors.warningLight,
        StatusLevel.danger => AppColors.dangerLight,
        StatusLevel.info => AppColors.infoLight,
        StatusLevel.neutral => AppColors.surfaceTinted,
      };

  Color get _foregroundColor => switch (level) {
        StatusLevel.success => AppColors.success,
        StatusLevel.warning => AppColors.warning,
        StatusLevel.danger => AppColors.danger,
        StatusLevel.info => AppColors.info,
        StatusLevel.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: _foregroundColor),
            const SizedBox(width: 5),
          ] else if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: _foregroundColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: _foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
