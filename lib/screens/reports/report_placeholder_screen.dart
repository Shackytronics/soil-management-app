import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';

class ReportPlaceholderScreen extends StatelessWidget {
  const ReportPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Export Report'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondaryUltraLight,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.download_outlined,
                  size: 56,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Export Coming Soon',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Report export will be available after the Hive local database, Measurements module, and History module are fully implemented.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _RoadmapItem(
                icon: Icons.storage_outlined,
                label: 'Hive Architecture',
                done: false,
              ),
              const SizedBox(height: 10),
              _RoadmapItem(
                icon: Icons.science_outlined,
                label: 'Measurements Module',
                done: false,
              ),
              const SizedBox(height: 10),
              _RoadmapItem(
                icon: Icons.history_rounded,
                label: 'History Module',
                done: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapItem extends StatelessWidget {
  const _RoadmapItem({required this.icon, required this.label, required this.done});

  final IconData icon;
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: done ? AppColors.successLight : AppColors.surfaceTinted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: done ? AppColors.success : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_outline : icon,
            color: done ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: done ? AppColors.success : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: done ? AppColors.success : AppColors.warning,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              done ? 'Done' : 'Pending',
              style: AppTypography.caption.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
