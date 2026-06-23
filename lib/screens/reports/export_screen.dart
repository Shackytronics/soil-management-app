import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/measurement_model.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/export/excel_export_service.dart';
import '../../services/export/pdf_export_service.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTimeRange? _dateRange;
  String? _selectedPlotId;
  late String _format;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _format = context.read<SettingsProvider>().defaultExportFormat;
  }

  @override
  Widget build(BuildContext context) {
    final plots = context.watch<PlotProvider>().plots;
    final meas = context.watch<MeasurementProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Report'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Filters ─────────────────────────────────────────────────────────
          _SectionLabel('FILTERS'),
          const SizedBox(height: 10),
          _FilterCard(
            label: 'Date Range',
            value: _dateRange == null
                ? 'All time'
                : '${_formatDate(_dateRange!.start)} – ${_formatDate(_dateRange!.end)}',
            icon: Icons.date_range_rounded,
            onTap: _pickDateRange,
            onClear: _dateRange != null ? () => setState(() => _dateRange = null) : null,
          ),
          const SizedBox(height: 10),
          _FilterCard(
            label: 'Plot',
            value: _selectedPlotId == null
                ? 'All plots'
                : plots.firstWhere((p) => p.id == _selectedPlotId).name,
            icon: Icons.grass_rounded,
            onTap: plots.isEmpty ? null : _pickPlot,
            onClear: _selectedPlotId != null
                ? () => setState(() => _selectedPlotId = null)
                : null,
          ),
          const SizedBox(height: 24),

          // ── Format ──────────────────────────────────────────────────────────
          _SectionLabel('FORMAT'),
          const SizedBox(height: 10),
          _FormatToggle(
            selected: _format,
            onChanged: (v) => setState(() => _format = v),
          ),
          const SizedBox(height: 24),

          // ── Preview count ───────────────────────────────────────────────────
          _PreviewBanner(
            count: _filteredMeasurements(meas).length,
            total: meas.count,
          ),
          const SizedBox(height: 28),

          // ── Export button ───────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : () => _export(meas),
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Icon(
                      _format == 'pdf'
                          ? Icons.picture_as_pdf_rounded
                          : Icons.table_chart_rounded,
                    ),
              label: Text(_loading ? 'Preparing…' : 'Export & Share'),
            ),
          ),
        ],
      ),
    );
  }

  List<MeasurementModel> _filteredMeasurements(MeasurementProvider meas) {
    var list = meas.measurements;
    if (_selectedPlotId != null) {
      list = list.where((m) => m.plotId == _selectedPlotId).toList();
    }
    if (_dateRange != null) {
      list = list.where((m) {
        return m.recordedAt.isAfter(
                  _dateRange!.start.subtract(const Duration(seconds: 1))) &&
              m.recordedAt.isBefore(
                  _dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    return list;
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (range != null) setState(() => _dateRange = range);
  }

  Future<void> _pickPlot() async {
    final plots = context.read<PlotProvider>().plots;
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Select Plot', style: AppTypography.headingSmall),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.all_inclusive_rounded),
            title: const Text('All Plots'),
            onTap: () => Navigator.pop(context, ''),
          ),
          ...plots.map((p) => ListTile(
                leading: const Icon(Icons.grass_rounded),
                title: Text(p.name),
                subtitle: Text(p.location),
                onTap: () => Navigator.pop(context, p.id),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
    if (result != null) {
      setState(() => _selectedPlotId = result.isEmpty ? null : result);
    }
  }

  Future<void> _export(MeasurementProvider meas) async {
    final data = _filteredMeasurements(meas);

    if (data.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No measurements match your filters')),
      );
      return;
    }

    setState(() => _loading = true);
    final farmerName = FirebaseAuth.instance.currentUser?.displayName ??
        FirebaseAuth.instance.currentUser?.email?.split('@').first ??
        'Farmer';

    try {
      if (_format == 'pdf') {
        await PdfExportService.shareReport(
          measurements: data,
          farmerName: farmerName,
          dateRange: _dateRange,
          plotName: _selectedPlotId == null
              ? null
              : context
                  .read<PlotProvider>()
                  .plots
                  .firstWhere((p) => p.id == _selectedPlotId)
                  .name,
        );
      } else {
        await ExcelExportService.shareReport(
          measurements: data,
          farmerName: farmerName,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTypography.overline,
      );
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.onClear,
  });
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.caption),
                    const SizedBox(height: 2),
                    Text(value, style: AppTypography.labelMedium),
                  ],
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Icon(Icons.close, size: 18, color: AppColors.textHint),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatToggle extends StatelessWidget {
  const _FormatToggle({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FormatOption(
            icon: Icons.picture_as_pdf_rounded,
            label: 'PDF',
            subtitle: 'Share-ready document',
            value: 'pdf',
            selected: selected == 'pdf',
            onTap: () => onChanged('pdf'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FormatOption(
            icon: Icons.table_chart_rounded,
            label: 'Excel',
            subtitle: 'Spreadsheet (.xlsx)',
            value: 'excel',
            selected: selected == 'excel',
            onTap: () => onChanged('excel'),
          ),
        ),
      ],
    );
  }
}

class _FormatOption extends StatelessWidget {
  const _FormatOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryUltraLight : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: selected ? AppColors.primaryMid : AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner({required this.count, required this.total});
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: count > 0 ? AppColors.infoLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: count > 0
              ? AppColors.info.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            count > 0 ? Icons.info_outline : Icons.warning_amber_rounded,
            color: count > 0 ? AppColors.info : AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              count > 0
                  ? '$count of $total measurement${count == 1 ? '' : 's'} will be exported'
                  : 'No measurements match the selected filters',
              style: AppTypography.bodySmall.copyWith(
                color: count > 0 ? AppColors.info : AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
