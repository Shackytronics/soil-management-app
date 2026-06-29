import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/plot_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/plot_provider.dart';
import 'add_plot_screen.dart';
import 'plot_detail_screen.dart';

class PlotsScreen extends StatelessWidget {
  const PlotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.dashMyPlots),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchBar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddPlotScreen()),
            ),
          ),
        ],
      ),
      body: const _PlotsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const AddPlotScreen())),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(
          context.l10n.actionAddPlot,
          style: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        onChanged: context.read<PlotProvider>().setSearchQuery,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: context.l10n.plotsSearch,
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

class _PlotsList extends StatelessWidget {
  const _PlotsList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlotProvider>();
    final plots = provider.filtered;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (plots.isEmpty) {
      return _EmptyState(hasSearch: provider.searchQuery.isNotEmpty);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: plots.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _PlotCard(plot: plots[i]),
    );
  }
}

class _PlotCard extends StatelessWidget {
  const _PlotCard({required this.plot});
  final PlotModel plot;

  @override
  Widget build(BuildContext context) {
    final measurementCount =
        context.watch<MeasurementProvider>().forPlot(plot.id).length;

    return Material(
      color: AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => PlotDetailScreen(plotId: plot.id)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                  gradient: AppGradients.primaryHero,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.grass_rounded,
                    color: AppColors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plot.name, style: AppTypography.labelMedium),
                    const SizedBox(height: 3),
                    Text(
                      plot.location.isNotEmpty
                          ? plot.location
                          : plot.cropType,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Badge(
                          icon: Icons.straighten_outlined,
                          label: context.l10n.plotSizeBadge('${plot.sizeAcres}'),
                          color: AppColors.primaryGlass20,
                        ),
                        const SizedBox(width: 6),
                        _Badge(
                          icon: Icons.science_outlined,
                          label:
                              context.l10n.plotMeasurementsCount(measurementCount),
                          color: AppColors.primaryGlass10,
                        ),
                      ],
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
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryUltraLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasSearch});
  final bool hasSearch;

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
              child: const Icon(Icons.grass_rounded,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              hasSearch
                  ? context.l10n.plotsNotFound
                  : context.l10n.plotsEmptyTitle,
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? context.l10n.plotsTryDifferent
                  : context.l10n.plotsEmptyBody,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const AddPlotScreen())),
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: Text(context.l10n.plotAddFirst),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
