import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/measurement_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';
import '../measurements/measurement_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedPlotId;
  DateTimeRange? _dateRange;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            onPressed: () => _showFilterSheet(context),
          ),
          if (_selectedPlotId != null ||
              _dateRange != null ||
              _search.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_list_off, color: AppColors.white),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (v) => setState(() => _search = v),
          ),
          Expanded(child: _HistoryBody(
            plotId: _selectedPlotId,
            dateRange: _dateRange,
            search: _search,
          )),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _selectedPlotId = null;
      _dateRange = null;
      _search = '';
    });
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FilterSheet(
        plots: context.read<PlotProvider>().plots,
        selectedPlotId: _selectedPlotId,
        dateRange: _dateRange,
        onPlotChanged: (id) => setState(() => _selectedPlotId = id),
        onDateRangeChanged: (range) => setState(() => _dateRange = range),
        onClear: () {
          setState(() {
            _selectedPlotId = null;
            _dateRange = null;
          });
        },
      ),
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: TextField(
        onChanged: onChanged,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search by plot or notes...',
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

// ─── Filter bottom sheet ──────────────────────────────────────────────────────

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({
    required this.plots,
    required this.selectedPlotId,
    required this.dateRange,
    required this.onPlotChanged,
    required this.onDateRangeChanged,
    required this.onClear,
  });

  final List plots;
  final String? selectedPlotId;
  final DateTimeRange? dateRange;
  final ValueChanged<String?> onPlotChanged;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filter History', style: AppTypography.headingSmall),
              const Spacer(),
              TextButton(
                onPressed: () {
                  onClear();
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Plot', style: AppTypography.overline),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedPlotId == null,
                onSelected: (_) => onPlotChanged(null),
              ),
              ...plots.map((p) => FilterChip(
                    label: Text(p.name as String),
                    selected: selectedPlotId == p.id,
                    onSelected: (_) => onPlotChanged(p.id as String),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Text('Date Range', style: AppTypography.overline),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.date_range_outlined),
              label: Text(dateRange == null
                  ? 'Select Date Range'
                  : '${_fmt(dateRange!.start)} – ${_fmt(dateRange!.end)}'),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) onDateRangeChanged(range);
              },
            ),
          ),
          if (dateRange != null)
            TextButton(
              onPressed: () => onDateRangeChanged(null),
              child: const Text('Clear date'),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

// ─── Main history body ────────────────────────────────────────────────────────

class _HistoryBody extends StatelessWidget {
  const _HistoryBody({
    required this.plotId,
    required this.dateRange,
    required this.search,
  });
  final String? plotId;
  final DateTimeRange? dateRange;
  final String search;

  List<MeasurementModel> _applyFilters(List<MeasurementModel> all) {
    var list = all;

    if (plotId != null) {
      list = list.where((m) => m.plotId == plotId).toList();
    }

    if (dateRange != null) {
      list = list.where((m) {
        return m.recordedAt.isAfter(dateRange!.start) &&
            m.recordedAt.isBefore(
              dateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    if (search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list
          .where((m) =>
              m.plotName.toLowerCase().contains(q) ||
              (m.notes?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final all = context.watch<MeasurementProvider>().measurements;
    final filtered = _applyFilters(all);

    if (all.isEmpty) {
      return const _EmptyState();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text('No results match your filters',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary)),
      );
    }

    // Group by month
    final grouped = <String, List<MeasurementModel>>{};
    for (final m in filtered) {
      final key = _monthKey(m.recordedAt);
      grouped.putIfAbsent(key, () => []).add(m);
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _StatisticsSummary(measurements: filtered)),
        ...grouped.entries.expand((entry) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(entry.key,
                      style: AppTypography.overline),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final m = entry.value[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: _HistoryTile(m: m),
                    );
                  },
                  childCount: entry.value.length,
                ),
              ),
            ]),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  String _monthKey(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

// ─── Statistics summary ───────────────────────────────────────────────────────

class _StatisticsSummary extends StatelessWidget {
  const _StatisticsSummary({required this.measurements});
  final List<MeasurementModel> measurements;

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) return const SizedBox.shrink();

    final count = measurements.length;
    final avgPh =
        measurements.map((m) => m.ph).reduce((a, b) => a + b) / count;
    final avgN =
        measurements.map((m) => m.nitrogen).reduce((a, b) => a + b) / count;
    final avgP =
        measurements.map((m) => m.phosphorus).reduce((a, b) => a + b) / count;
    final avgK =
        measurements.map((m) => m.potassium).reduce((a, b) => a + b) / count;
    final avgMoisture =
        measurements.map((m) => m.moisture).reduce((a, b) => a + b) / count;
    final avgTemp =
        measurements.map((m) => m.temperature).reduce((a, b) => a + b) / count;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryHero,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Text('Summary', style: AppTypography.onDarkLabelLarge),
                const Spacer(),
                Text('$count readings',
                    style: AppTypography.onDarkCaption),
              ],
            ),
          ),
          const Divider(color: AppColors.glass20, height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _SumStat('pH', avgPh.toStringAsFixed(1), AppColors.phColor),
                _SumStat('N', '${avgN.toStringAsFixed(0)} mg/kg', AppColors.nitrogenColor),
                _SumStat('P', '${avgP.toStringAsFixed(0)} mg/kg', AppColors.phosphorusColor),
                _SumStat('K', '${avgK.toStringAsFixed(0)} mg/kg', AppColors.potassiumColor),
                _SumStat('H₂O', '${avgMoisture.toStringAsFixed(0)}%', AppColors.moistureColor),
                _SumStat('°C', avgTemp.toStringAsFixed(0), AppColors.temperatureColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SumStat extends StatelessWidget {
  const _SumStat(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label: $value',
        style: AppTypography.caption.copyWith(color: AppColors.white),
      ),
    );
  }
}

// ─── History tile ─────────────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.m});
  final MeasurementModel m;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) =>
                  MeasurementDetailScreen(measurementId: m.id)),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryHero,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${m.recordedAt.day}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      _monthShort(m.recordedAt.month),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textOnDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.plotName, style: AppTypography.labelMedium),
                    const SizedBox(height: 3),
                    Text(
                      'pH ${m.ph.toStringAsFixed(1)}  ·  H₂O ${m.moisture.toStringAsFixed(0)}%  ·  N ${m.nitrogen.toStringAsFixed(0)} mg/kg',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${m.recordedAt.hour.toString().padLeft(2, '0')}:${m.recordedAt.minute.toString().padLeft(2, '0')}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    m.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                    size: 14,
                    color: m.isSynced ? AppColors.success : AppColors.textHint,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthShort(int month) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month - 1];
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
              child: const Icon(Icons.history, size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text('No History Yet', style: AppTypography.headingMedium),
            const SizedBox(height: 8),
            Text(
              'Your measurement history will appear here after you add readings.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
