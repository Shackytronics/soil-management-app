import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glass20,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glass30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.onDarkLabelLarge),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTypography.onDarkCaption),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class ChartEmptyState extends StatelessWidget {
  const ChartEmptyState(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          message,
          style: AppTypography.onDarkCaption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
