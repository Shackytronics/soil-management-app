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
import '../soil_management/soil_management_screen.dart';
import 'edit_measurement_screen.dart';

class MeasurementDetailScreen extends StatelessWidget {
  const MeasurementDetailScreen({super.key, required this.measurementId});
  final String measurementId;

  @override
  Widget build(BuildContext context) {
    MeasurementModel? m;
    try {
      m = context
          .watch<MeasurementProvider>()
          .measurements
          .firstWhere((e) => e.id == measurementId);
    } catch (_) {}

    if (m == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.measDetails)),
        body: Center(child: Text(context.l10n.measNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _DetailSliverAppBar(m: m),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdvisorySection(m: m),
                  const SizedBox(height: 16),
                  _NutrientSection(m: m),
                  const SizedBox(height: 16),
                  _ConditionSection(m: m),
                  const SizedBox(height: 16),
                  _MetaCard(m: m),
                  if (m.notes != null && m.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _NotesCard(notes: m.notes!),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSliverAppBar extends StatelessWidget {
  const _DetailSliverAppBar({required this.m});
  final MeasurementModel m;

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
          icon: const Icon(Icons.edit_outlined, color: AppColors.white),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => EditMeasurementScreen(measurement: m)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.white),
          onPressed: () => _confirmDelete(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          m.plotName,
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
              child: Text(
                _fmtDate(m.recordedAt),
                style: AppTypography.onDarkCaption,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<bool>(
      context: context,
      // Pop with the dialog's own context: the dialog lives on the root
      // navigator, while `context` belongs to the tab's nested navigator
      // (MainShell._TabNavigator). Popping with the wrong context closes the
      // nested navigator instead of the dialog, so it never returns.
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.measDeleteTitle),
        content: Text(context.l10n.measDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(context.l10n.actionDelete),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && context.mounted) {
        await context.read<MeasurementProvider>().deleteMeasurement(m.id);
        if (context.mounted) Navigator.of(context).pop();
      }
    });
  }

  String _fmtDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _AdvisorySection extends StatelessWidget {
  const _AdvisorySection({required this.m});
  final MeasurementModel m;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SoilManagementScreen(measurementId: m.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recProvider = context.watch<RecommendationProvider>();
    final RecommendationModel? advisory = recProvider.forMeasurement(m.id);
    final isGenerating = recProvider.isGeneratingFor(m.id);

    final hasAdvisory = advisory != null;
    final healthColor =
        hasAdvisory ? _healthColor(advisory.soilHealth) : AppColors.primary;
    final count = advisory?.recommendations.length ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppGradients.primaryHero,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.glass20,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.glass30),
                ),
                child: const Icon(Icons.spa_rounded,
                    color: AppColors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.reportsAdvisoryTitle,
                        style: AppTypography.onDarkLabelLarge),
                    const SizedBox(height: 3),
                    if (isGenerating)
                      Text(context.l10n.smGeneratingShort,
                          style: AppTypography.onDarkCaption)
                    else if (hasAdvisory)
                      Row(
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: healthColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${advisory.soilHealth} · '
                              '${context.l10n.smScoreOutOf('${advisory.soilHealthScore}')} · '
                              '${context.l10n.smRecommendationCount(count)}',
                              style: AppTypography.onDarkCaption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(context.l10n.smTapToGenerate,
                          style: AppTypography.onDarkCaption),
                  ],
                ),
              ),
              if (isGenerating)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }

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
    return AppColors.white;
  }
}

class _NutrientSection extends StatelessWidget {
  const _NutrientSection({required this.m});
  final MeasurementModel m;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.measSoilNutrients,
      child: Column(
        children: [
          _ReadingRow(
            label: context.l10n.measNitrogen,
            value: m.nitrogen,
            unit: 'mg/kg',
            color: AppColors.nitrogenColor,
            min: 10,
            max: 30,
          ),
          const Divider(height: 1),
          _ReadingRow(
            label: context.l10n.measPhosphorus,
            value: m.phosphorus,
            unit: 'mg/kg',
            color: AppColors.phosphorusColor,
            min: 5,
            max: 30,
          ),
          const Divider(height: 1),
          _ReadingRow(
            label: context.l10n.measPotassium,
            value: m.potassium,
            unit: 'mg/kg',
            color: AppColors.potassiumColor,
            min: 100,
            max: 300,
          ),
        ],
      ),
    );
  }
}

class _ConditionSection extends StatelessWidget {
  const _ConditionSection({required this.m});
  final MeasurementModel m;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.measSoilConditions,
      child: Column(
        children: [
          _ReadingRow(
            label: context.l10n.measPh,
            value: m.ph,
            unit: '',
            color: AppColors.phColor,
            min: 6.0,
            max: 7.5,
          ),
          const Divider(height: 1),
          _ReadingRow(
            label: context.l10n.measMoisture,
            value: m.moisture,
            unit: '%',
            color: AppColors.moistureColor,
            min: 40,
            max: 70,
          ),
          const Divider(height: 1),
          _ReadingRow(
            label: context.l10n.measTemperature,
            value: m.temperature,
            unit: '°C',
            color: AppColors.temperatureColor,
            min: 15,
            max: 35,
          ),
          const Divider(height: 1),
          _ReadingRow(
            label: context.l10n.measEc,
            value: m.ec,
            unit: 'mS/cm',
            color: AppColors.conductivityColor,
            min: 0.2,
            max: 1.0,
          ),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.min,
    required this.max,
  });
  final String label;
  final double value;
  final String unit;
  final Color color;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inRange = value >= min && value <= max;
    final near = !inRange && value >= min * 0.8 && value <= max * 1.2;
    final statusColor = inRange
        ? AppColors.success
        : near
            ? AppColors.warning
            : AppColors.danger;
    final statusLabel = inRange
        ? l10n.measStatusOptimal
        : near
            ? l10n.measStatusNear
            : l10n.measStatusOff;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelMedium.copyWith(fontSize: 13)),
                Text(
                  l10n.measOptimalRange(
                    '$min',
                    '$max',
                    unit.isNotEmpty ? ' $unit' : '',
                  ),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${value.toStringAsFixed(value >= 10 ? 0 : 2)}${unit.isNotEmpty ? ' $unit' : ''}',
                style: AppTypography.numericSmall
                    .copyWith(color: color, fontSize: 16),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.caption.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.m});
  final MeasurementModel m;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Section(
      title: l10n.measDetailsSection,
      child: Column(
        children: [
          _MetaRow(Icons.grass_outlined, l10n.measFieldPlot, m.plotName),
          const Divider(height: 1),
          _MetaRow(Icons.calendar_today_outlined, l10n.measFieldRecorded,
              _fmtDate(m.recordedAt)),
          const Divider(height: 1),
          _MetaRow(
            Icons.cloud_done_outlined,
            l10n.measSyncStatus,
            m.isSynced ? l10n.measSyncedToCloud : l10n.measPendingSync,
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(label, style: AppTypography.bodyMedium),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});
  final String notes;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.measNotes,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(notes, style: AppTypography.bodyMedium),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTypography.overline),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: child,
        ),
      ],
    );
  }
}
