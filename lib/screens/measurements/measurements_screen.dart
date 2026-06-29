import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/measurement_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';
import 'add_measurement_screen.dart';
import 'measurement_detail_screen.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.measTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchFilterBar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: const _MeasurementBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMeasurementScreen()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_chart_rounded),
        label: Text(
          context.l10n.measAddReading,
          style: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<MeasurementProvider>(),
        child: ChangeNotifierProvider.value(
          value: context.read<PlotProvider>(),
          child: const _FilterSheet(),
        ),
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        onChanged: context.read<MeasurementProvider>().setSearchQuery,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: context.l10n.measSearchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context) {
    final measProv = context.watch<MeasurementProvider>();
    final plots = context.watch<PlotProvider>().plots;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(context.l10n.measFilters, style: AppTypography.headingSmall),
              const Spacer(),
              TextButton(
                onPressed: () {
                  measProv.clearFilters();
                  Navigator.pop(context);
                },
                child: Text(context.l10n.measClearAll),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(context.l10n.measFilterByPlot, style: AppTypography.overline),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              FilterChip(
                label: Text(context.l10n.measAllPlots),
                selected: measProv.filterPlotId == null,
                onSelected: (_) => measProv.setFilterPlot(null),
              ),
              ...plots.map((p) => FilterChip(
                    label: Text(p.name),
                    selected: measProv.filterPlotId == p.id,
                    onSelected: (_) => measProv.setFilterPlot(p.id),
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Text(context.l10n.measFilterByDate, style: AppTypography.overline),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.date_range_outlined),
              label: Text(
                measProv.filterDateRange == null
                    ? context.l10n.histSelectDateRange
                    : '${_fmtDate(measProv.filterDateRange!.start)} – ${_fmtDate(measProv.filterDateRange!.end)}',
              ),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) measProv.setFilterDateRange(range);
              },
            ),
          ),
          if (measProv.filterDateRange != null)
            TextButton(
              onPressed: () => measProv.setFilterDateRange(null),
              child: Text(context.l10n.measClearDateFilter),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.measApplyFilters),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _MeasurementBody extends StatelessWidget {
  const _MeasurementBody();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MeasurementProvider>();
    final list = prov.filtered;

    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.measurements.isEmpty) {
      return const _EmptyState();
    }

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_list_off, size: 56, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(context.l10n.histNoResults,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: prov.clearFilters,
              child: Text(context.l10n.measClearFilters),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (prov.filterPlotId != null || prov.filterDateRange != null)
          _ActiveFiltersBar(prov: prov),
        _StatsRow(measurements: list),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) =>
                _MeasurementCard(measurement: list[i]),
          ),
        ),
      ],
    );
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  const _ActiveFiltersBar({required this.prov});
  final MeasurementProvider prov;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primaryUltraLight,
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(context.l10n.measFiltersActive,
              style: AppTypography.caption
                  .copyWith(color: AppColors.primary)),
          const Spacer(),
          GestureDetector(
            onTap: prov.clearFilters,
            child: const Icon(Icons.close, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.measurements});
  final List<MeasurementModel> measurements;

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) return const SizedBox.shrink();
    final count = measurements.length;
    final avgPh =
        measurements.map((m) => m.ph).reduce((a, b) => a + b) / count;
    final avgMoisture =
        measurements.map((m) => m.moisture).reduce((a, b) => a + b) / count;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryHero,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniStat(
                '$count', context.l10n.measStatTotal, Icons.science_rounded),
          ),
          Expanded(
            child: _MiniStat(
                avgPh.toStringAsFixed(1),
                context.l10n.measStatAvgPh,
                Icons.water_drop_outlined),
          ),
          Expanded(
            child: _MiniStat(
                '${avgMoisture.toStringAsFixed(0)}%',
                context.l10n.measStatAvgMoisture,
                Icons.opacity_outlined),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.value, this.label, this.icon);
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 16),
        const SizedBox(height: 4),
        Text(value,
            style: AppTypography.onDarkHeadingSmall.copyWith(fontSize: 15)),
        Text(label, style: AppTypography.onDarkCaption),
      ],
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  const _MeasurementCard({required this.measurement});
  final MeasurementModel measurement;

  @override
  Widget build(BuildContext context) {
    final m = measurement;
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) =>
                  MeasurementDetailScreen(measurementId: m.id)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryHero,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.science_rounded,
                        color: AppColors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.plotName, style: AppTypography.labelMedium),
                        Text(
                          _fmtDate(m.recordedAt),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textHint),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _NutrientBadge('N',
                        '${m.nitrogen.toStringAsFixed(0)} mg/kg',
                        AppColors.nitrogenColor),
                    const SizedBox(width: 6),
                    _NutrientBadge('P',
                        '${m.phosphorus.toStringAsFixed(0)} mg/kg',
                        AppColors.phosphorusColor),
                    const SizedBox(width: 6),
                    _NutrientBadge('K',
                        '${m.potassium.toStringAsFixed(0)} mg/kg',
                        AppColors.potassiumColor),
                    const SizedBox(width: 6),
                    _NutrientBadge(
                        'pH', m.ph.toStringAsFixed(1), AppColors.phColor),
                    const SizedBox(width: 6),
                    _NutrientBadge('H₂O',
                        '${m.moisture.toStringAsFixed(0)}%',
                        AppColors.moistureColor),
                    const SizedBox(width: 6),
                    _NutrientBadge('°C',
                        m.temperature.toStringAsFixed(0),
                        AppColors.temperatureColor),
                    const SizedBox(width: 6),
                    _NutrientBadge('EC',
                        '${m.ec.toStringAsFixed(2)} mS',
                        AppColors.conductivityColor),
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _NutrientBadge extends StatelessWidget {
  const _NutrientBadge(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 11, height: 1.3),
          children: [
            TextSpan(
                text: '$label: ',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600)),
            TextSpan(
                text: value,
                style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
              child: const Icon(Icons.science_outlined,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(context.l10n.measEmptyTitle,
                style: AppTypography.headingMedium),
            const SizedBox(height: 8),
            Text(
              context.l10n.measEmptyBody,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const AddMeasurementScreen())),
                icon: const Icon(Icons.add_chart_rounded),
                label: Text(context.l10n.measAddFirstReading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
