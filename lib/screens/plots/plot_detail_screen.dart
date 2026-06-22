import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/measurement_model.dart';
import '../../data/models/plot_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';
import '../measurements/add_measurement_screen.dart';
import '../measurements/measurement_detail_screen.dart';
import 'edit_plot_screen.dart';

class PlotDetailScreen extends StatelessWidget {
  const PlotDetailScreen({super.key, required this.plotId});
  final String plotId;

  @override
  Widget build(BuildContext context) {
    final plot = context.watch<PlotProvider>().getById(plotId);

    if (plot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Plot')),
        body: const Center(child: Text('Plot not found')),
      );
    }

    final measurements =
        context.watch<MeasurementProvider>().forPlot(plotId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _PlotSliverAppBar(plot: plot),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PlotInfoCard(plot: plot),
                  const SizedBox(height: 16),
                  _MeasurementsSummary(measurements: measurements),
                  const SizedBox(height: 16),
                  _MeasurementsList(
                    measurements: measurements,
                    plotId: plotId,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMeasurementScreen(preselectedPlot: plot),
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_chart_rounded),
        label: const Text(
          'Add Reading',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _PlotSliverAppBar extends StatelessWidget {
  const _PlotSliverAppBar({required this.plot});
  final PlotModel plot;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: AppColors.white),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => EditPlotScreen(plot: plot)),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.white),
          onPressed: () => _confirmDelete(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          plot.name,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.glass30,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.eco_outlined,
                              color: AppColors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            plot.cropType,
                            style: AppTypography.onDarkCaption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (plot.sizeAcres > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.glass30,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${plot.sizeAcres} acres',
                          style: AppTypography.onDarkCaption,
                        ),
                      ),
                  ],
                ),
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
      builder: (_) => AlertDialog(
        title: const Text('Delete Plot'),
        content: Text(
            'Delete "${plot.name}"? All measurements for this plot will remain.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && context.mounted) {
        await context.read<PlotProvider>().deletePlot(plot.id);
        if (context.mounted) Navigator.of(context).pop();
      }
    });
  }
}

class _PlotInfoCard extends StatelessWidget {
  const _PlotInfoCard({required this.plot});
  final PlotModel plot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plot Details', style: AppTypography.labelMedium),
          const SizedBox(height: 12),
          if (plot.location.isNotEmpty)
            _InfoRow(
                icon: Icons.location_on_outlined, label: plot.location),
          _InfoRow(
              icon: Icons.eco_outlined, label: plot.cropType),
          if (plot.sizeAcres > 0)
            _InfoRow(
                icon: Icons.straighten_outlined,
                label: '${plot.sizeAcres} acres'),
          if (plot.description.isNotEmpty)
            _InfoRow(
                icon: Icons.notes_outlined, label: plot.description),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label:
                'Added ${_formatDate(plot.createdAt)}',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _MeasurementsSummary extends StatelessWidget {
  const _MeasurementsSummary({required this.measurements});
  final List<MeasurementModel> measurements;

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) return const SizedBox.shrink();

    final count = measurements.length;
    final avgPh =
        measurements.map((m) => m.ph).reduce((a, b) => a + b) / count;
    final avgMoisture =
        measurements.map((m) => m.moisture).reduce((a, b) => a + b) / count;
    final avgN =
        measurements.map((m) => m.nitrogen).reduce((a, b) => a + b) / count;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryHero,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
              child: _SumChip('Readings', '$count', Icons.science_rounded)),
          Expanded(
              child: _SumChip('Avg pH', avgPh.toStringAsFixed(1), Icons.water_drop_outlined)),
          Expanded(
              child: _SumChip('Avg H₂O', '${avgMoisture.toStringAsFixed(0)}%', Icons.opacity_outlined)),
          Expanded(
              child: _SumChip('Avg N', avgN.toStringAsFixed(0), Icons.eco_outlined)),
        ],
      ),
    );
  }
}

class _SumChip extends StatelessWidget {
  const _SumChip(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: AppTypography.onDarkHeadingSmall
                .copyWith(fontSize: 15)),
        Text(label, style: AppTypography.onDarkCaption),
      ],
    );
  }
}

class _MeasurementsList extends StatelessWidget {
  const _MeasurementsList({
    required this.measurements,
    required this.plotId,
  });
  final List<MeasurementModel> measurements;
  final String plotId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Measurement History', style: AppTypography.headingSmall),
        const SizedBox(height: 10),
        if (measurements.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.science_outlined,
                      size: 40, color: AppColors.textHint),
                  const SizedBox(height: 10),
                  Text('No readings yet',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: measurements.length,
            separatorBuilder: (_, i) => const SizedBox(height: 8),
            itemBuilder: (context, i) =>
                _MeasurementTile(m: measurements[i]),
          ),
      ],
    );
  }
}

class _MeasurementTile extends StatelessWidget {
  const _MeasurementTile({required this.m});
  final MeasurementModel m;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => MeasurementDetailScreen(measurementId: m.id)),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.science_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(m.recordedAt),
                      style: AppTypography.labelMedium.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'pH ${m.ph.toStringAsFixed(1)}  ·  H₂O ${m.moisture.toStringAsFixed(0)}%  ·  N ${m.nitrogen.toStringAsFixed(0)} mg/kg',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
