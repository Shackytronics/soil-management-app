import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/recommendation_provider.dart';
import '../history/history_screen.dart';
import '../soil_management/soil_management_screen.dart';
import 'export_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final latestAdvisory = context.watch<RecommendationProvider>().latest;
    final advisorySubtitle = latestAdvisory == null
        ? context.l10n.reportsAdvisorySubtitle
        : '${latestAdvisory.soilHealth} · '
            '${context.l10n.smScoreOutOf('${latestAdvisory.soilHealthScore}')}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.reportsTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Text(
            context.l10n.reportsAvailable,
            style: AppTypography.overline,
          ),
          const SizedBox(height: 12),
          _ReportOptionCard(
            icon: Icons.spa_rounded,
            title: context.l10n.reportsAdvisoryTitle,
            subtitle: advisorySubtitle,
            color: AppColors.primary,
            onTap: () {
              final id = context.read<RecommendationProvider>().latest
                      ?.measurementId ??
                  context.read<MeasurementProvider>().latest?.id;
              if (id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.reportsNeedMeasurement),
                  ),
                );
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SoilManagementScreen(measurementId: id),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ReportOptionCard(
            icon: Icons.history_rounded,
            title: context.l10n.reportsHistoryTitle,
            subtitle: context.l10n.reportsHistorySubtitle,
            color: AppColors.info,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ReportOptionCard(
            icon: Icons.download_rounded,
            title: context.l10n.reportsExportTitle,
            subtitle: context.l10n.reportsExportSubtitle,
            color: AppColors.secondary,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ExportScreen(),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.reportsSensorNote,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportOptionCard extends StatelessWidget {
  const _ReportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
