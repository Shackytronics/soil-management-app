import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/measurement_model.dart';
import '../../data/models/recommendation_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/recommendation_provider.dart';

/// Rule-Based Soil Management Advisory screen.
///
/// Displays the soil health status, overall status and the structured
/// recommendations returned by the Django Rule-Based Soil Management Engine
/// for a single measurement. Works offline by showing cached Hive advisories.
class SoilManagementScreen extends StatelessWidget {
  const SoilManagementScreen({super.key, required this.measurementId});

  final String measurementId;

  @override
  Widget build(BuildContext context) {
    final measProvider = context.watch<MeasurementProvider>();
    final recProvider = context.watch<RecommendationProvider>();

    MeasurementModel? measurement;
    for (final m in measProvider.measurements) {
      if (m.id == measurementId) {
        measurement = m;
        break;
      }
    }

    final advisory = recProvider.forMeasurement(measurementId);
    final isGenerating = recProvider.isGeneratingFor(measurementId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _AppBar(
            plotName: measurement?.plotName ?? advisory?.plotName ?? 'Soil Advisory',
            canRefresh: measurement != null && !isGenerating,
            onRefresh: measurement == null
                ? null
                : () => context
                    .read<RecommendationProvider>()
                    .generateForMeasurement(measurement!),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: _Body(
                measurement: measurement,
                advisory: advisory,
                isGenerating: isGenerating,
                error: recProvider.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.plotName,
    required this.canRefresh,
    required this.onRefresh,
  });

  final String plotName;
  final bool canRefresh;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        IconButton(
          tooltip: 'Refresh advisory',
          icon: const Icon(Icons.refresh_rounded, color: AppColors.white),
          onPressed: canRefresh ? onRefresh : null,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          context.l10n.smTitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 52),
              child: Text(plotName, style: AppTypography.onDarkCaption),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.measurement,
    required this.advisory,
    required this.isGenerating,
    required this.error,
  });

  final MeasurementModel? measurement;
  final RecommendationModel? advisory;
  final bool isGenerating;
  final AdvisoryError? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Generating with no cached advisory yet → full-screen loader.
    if (isGenerating && advisory == null) {
      return const _GeneratingState();
    }

    // No advisory at all → professional empty state.
    if (advisory == null) {
      return _EmptyState(
        canGenerate: measurement != null,
        errorText: error == null ? null : errorMessage(context, error!),
        onGenerate: measurement == null
            ? null
            : () => context
                .read<RecommendationProvider>()
                .generateForMeasurement(measurement!),
      );
    }

    final items = advisory!.recommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error != null) ...[
          _OfflineBanner(message: errorMessage(context, error!)),
          const SizedBox(height: 14),
        ],
        _StatusCard(advisory: advisory!),
        const SizedBox(height: 20),
        if (isGenerating) ...[
          const _InlineRefreshing(),
          const SizedBox(height: 14),
        ],
        Row(
          children: [
            Text(l10n.smRecommendations, style: AppTypography.overline),
            const Spacer(),
            Text(
              l10n.smItemsCount(items.length),
              style: AppTypography.caption,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          _NoActionsCard()
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecommendationCard(item: item),
            ),
          ),
        const SizedBox(height: 8),
        _GeneratedFooter(advisory: advisory!),
      ],
    );
  }
}

// ─── Status card ──────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.advisory});
  final RecommendationModel advisory;

  @override
  Widget build(BuildContext context) {
    final healthColor = _healthColor(advisory.soilHealth);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryHero,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.glass20,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glass30),
                ),
                child: const Icon(Icons.eco_rounded,
                    color: AppColors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.smHealthStatus,
                        style: AppTypography.onDarkCaption),
                    const SizedBox(height: 2),
                    Text(advisory.soilHealth,
                        style: AppTypography.onDarkHeadingLarge),
                  ],
                ),
              ),
              _ScoreBadge(
                score: advisory.soilHealthScore,
                color: healthColor,
              ),
            ],
          ),
          if (advisory.overallStatus.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.glass20,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.glass30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insights_rounded,
                      color: AppColors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.smOverallStatus,
                            style: AppTypography.onDarkCaption),
                        Text(advisory.overallStatus,
                            style: AppTypography.onDarkLabelLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Recommendation card ──────────────────────────────────────────────────────

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item});
  final RecommendationItem item;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(item.priority);
    final priorityLabel = _priorityLabel(context, item.priority);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(_iconFor(item.icon),
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.category.toUpperCase(),
                        style: AppTypography.overline
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: 2),
                    Text(item.title, style: AppTypography.labelMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _PriorityChip(label: priorityLabel, color: priorityColor),
            ],
          ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              item.description,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.color});
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${context.l10n.smHealthScore}: $score/100',
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.glass20,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: AppTypography.onDarkHeadingSmall.copyWith(
                color: AppColors.white,
                fontSize: 22,
                height: 1.0,
              ),
            ),
            Text(
              '/100',
              style: AppTypography.onDarkCaption.copyWith(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption
                .copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── Footer / banners ─────────────────────────────────────────────────────────

class _GeneratedFooter extends StatelessWidget {
  const _GeneratedFooter({required this.advisory});
  final RecommendationModel advisory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          advisory.isSynced
              ? Icons.cloud_done_outlined
              : Icons.cloud_off_outlined,
          size: 14,
          color: advisory.isSynced ? AppColors.success : AppColors.textHint,
        ),
        const SizedBox(width: 6),
        Text(
          context.l10n.smLastGenerated(_fmtDate(advisory.generatedAt)),
          style: AppTypography.caption,
        ),
      ],
    );
  }
}

class _InlineRefreshing extends StatelessWidget {
  const _InlineRefreshing();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(context.l10n.smUpdating,
              style: AppTypography.bodySmall.copyWith(color: AppColors.info)),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }
}

class _NoActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.success, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.smNoActionsHealthy,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── States ───────────────────────────────────────────────────────────────────

class _GeneratingState extends StatelessWidget {
  const _GeneratingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 20),
          Text(context.l10n.smGenerating, style: AppTypography.labelMedium),
          const SizedBox(height: 6),
          Text(
            context.l10n.smApplyingRules,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.canGenerate,
    required this.errorText,
    required this.onGenerate,
  });

  final bool canGenerate;
  final String? errorText;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryUltraLight,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.spa_outlined,
                size: 52, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(l10n.smNoAdvisoryTitle, style: AppTypography.headingMedium),
          const SizedBox(height: 8),
          Text(
            errorText ?? l10n.smNoAdvisoryBody,
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (canGenerate)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onGenerate,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l10n.smGenerateAdvisory),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Localization helpers ─────────────────────────────────────────────────────

String errorMessage(BuildContext context, AdvisoryError error) {
  final l10n = context.l10n;
  switch (error) {
    case AdvisoryError.offline:
      return l10n.smOfflineCached;
    case AdvisoryError.unauthorized:
      return l10n.smErrUnauthorized;
    case AdvisoryError.server:
      return l10n.smErrServer;
    case AdvisoryError.badResponse:
      return l10n.smErrBadResponse;
    case AdvisoryError.unknown:
      return l10n.smErrUnknown;
  }
}

String _priorityLabel(BuildContext context, String priority) {
  final l10n = context.l10n;
  switch (priority.toLowerCase()) {
    case 'high':
      return l10n.priorityHigh;
    case 'medium':
      return l10n.priorityMedium;
    case 'low':
      return l10n.priorityLow;
    default:
      return priority;
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Color _healthColor(String soilHealth) {
  final v = soilHealth.toLowerCase();
  if (v.contains('good') || v.contains('healthy') || v.contains('excellent')) {
    return AppColors.success;
  }
  if (v.contains('moderate') || v.contains('fair') || v.contains('average')) {
    return AppColors.warning;
  }
  if (v.contains('poor') || v.contains('low') || v.contains('critical')) {
    return AppColors.danger;
  }
  return AppColors.info;
}

Color _priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return AppColors.danger;
    case 'medium':
      return AppColors.warning;
    case 'low':
      return AppColors.success;
    default:
      return AppColors.info;
  }
}

IconData _iconFor(String name) {
  switch (name.toLowerCase()) {
    case 'compost':
      return Icons.compost_rounded;
    case 'water':
    case 'irrigation':
      return Icons.water_drop_outlined;
    case 'lime':
    case 'liming':
      return Icons.science_outlined;
    case 'mulch':
    case 'mulching':
      return Icons.grass_outlined;
    case 'organic':
    case 'organic_matter':
      return Icons.eco_outlined;
    case 'conservation':
    case 'soil_conservation':
      return Icons.terrain_outlined;
    case 'fertility':
    case 'fertilizer':
      return Icons.spa_outlined;
    case 'ph':
      return Icons.biotech_outlined;
    case 'temperature':
      return Icons.thermostat_outlined;
    case 'practice':
    case 'best_practice':
      return Icons.agriculture_outlined;
    default:
      return Icons.eco_rounded;
  }
}

String _fmtDate(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
