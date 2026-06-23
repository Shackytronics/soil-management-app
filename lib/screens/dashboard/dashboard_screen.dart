import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/plot_model.dart';
import '../../providers/measurement_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/plot_provider.dart';
import '../../providers/sync_status_provider.dart';
import '../measurements/add_measurement_screen.dart';
import '../plots/add_plot_screen.dart';
import '../plots/plot_detail_screen.dart';
import '../sensor/sensor_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/monthly_measurement_chart.dart';
import 'widgets/nutrient_comparison_chart.dart';
import 'widgets/soil_health_trend_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firstName = (user?.displayName?.split(' ').first ??
            user?.email?.split('@').first ??
            'Farmer')
        .toString();
    final hour = DateTime.now().hour;
    final greeting =
        hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primaryHero),
        child: SafeArea(
          child: Column(
            children: [
              _DashboardAppBar(greeting: greeting, name: firstName),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _QuickStatsRow(),
                      SizedBox(height: 20),
                      _SoilHealthCard(),
                      SizedBox(height: 16),
                      _LatestMeasurementCard(),
                      SizedBox(height: 16),
                      _AnalyticsSection(),
                      SizedBox(height: 16),
                      _PlotsSummaryStrip(),
                      SizedBox(height: 16),
                      _RecentActivitySection(),
                      SizedBox(height: 20),
                      _QuickActionsGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── App bar ──────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget {
  const _DashboardAppBar({required this.greeting, required this.name});
  final String greeting;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTypography.onDarkBodyMedium),
                const SizedBox(height: 2),
                Text(name, style: AppTypography.onDarkHeadingLarge),
              ],
            ),
          ),
          const _SyncChip(),
          const SizedBox(width: 8),
          _GlassIcon(
            icon: Icons.notifications_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SyncChip extends StatelessWidget {
  const _SyncChip();

  @override
  Widget build(BuildContext context) {
    final sync = context.watch<SyncStatusProvider>();

    final (IconData icon, Color color, String label, bool spinning) =
        switch (sync.syncState) {
      SyncState.syncing => (
          Icons.sync_rounded,
          AppColors.warning,
          'Syncing',
          true,
        ),
      SyncState.synced => (
          Icons.cloud_done_rounded,
          AppColors.success,
          'Synced',
          false,
        ),
      SyncState.error => (
          Icons.cloud_off_rounded,
          AppColors.danger,
          'Error',
          false,
        ),
      _ => sync.isOnline
          ? (Icons.cloud_outlined, AppColors.primaryLight, 'Online', false)
          : (Icons.cloud_off_outlined, AppColors.textHint, 'Offline', false),
    };

    return GestureDetector(
      onTap: sync.syncState == SyncState.error ? sync.triggerSync : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.glass20,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glass30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            spinning
                ? SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                : Icon(icon, color: color, size: 12),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.onDarkCaption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick stats ──────────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    final plots = context.watch<PlotProvider>();
    final meas = context.watch<MeasurementProvider>();
    final score = meas.healthScore;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.grass_rounded,
            label: 'Plots',
            value: '${plots.count}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.science_rounded,
            label: 'Readings',
            value: '${meas.count}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon: Icons.favorite_rounded,
            label: 'Health',
            value: meas.count == 0 ? '--' : '${score.round()}%',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: AppTypography.onDarkHeadingSmall
                  .copyWith(fontSize: 16)),
          Text(label, style: AppTypography.onDarkCaption),
        ],
      ),
    );
  }
}

// ─── Soil health summary card ─────────────────────────────────────────────────

class _SoilHealthCard extends StatelessWidget {
  const _SoilHealthCard();

  @override
  Widget build(BuildContext context) {
    final meas = context.watch<MeasurementProvider>();

    if (meas.count == 0) {
      return _GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.glass30,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.eco_rounded,
                  color: AppColors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Soil Health', style: AppTypography.onDarkLabelLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Add your first measurement to see soil health analysis.',
                    style: AppTypography.onDarkCaption,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final avg = meas.averages;
    final score = meas.healthScore;
    final label = score >= 70
        ? 'Good'
        : score >= 40
            ? 'Fair'
            : 'Poor';
    final color = score >= 70
        ? AppColors.success
        : score >= 40
            ? AppColors.warning
            : AppColors.danger;

    return _GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Soil Health', style: AppTypography.onDarkLabelLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.6)),
                ),
                child: Text(
                  '$label  ${score.round()}%',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 6,
              backgroundColor: AppColors.glass20,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _NutrientChip('N', avg['nitrogen'], 'mg/kg', AppColors.nitrogenColor),
              _NutrientChip('P', avg['phosphorus'], 'mg/kg', AppColors.phosphorusColor),
              _NutrientChip('K', avg['potassium'], 'mg/kg', AppColors.potassiumColor),
              _NutrientChip('pH', avg['ph'], '', AppColors.phColor),
              _NutrientChip('H₂O', avg['moisture'], '%', AppColors.moistureColor),
              _NutrientChip('°C', avg['temperature'], '', AppColors.temperatureColor),
              _NutrientChip('EC', avg['ec'], 'mS', AppColors.conductivityColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  const _NutrientChip(this.label, this.value, this.unit, this.color);
  final String label;
  final double? value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        value == null
            ? label
            : '$label: ${value!.toStringAsFixed(1)}$unit',
        style: AppTypography.caption.copyWith(color: AppColors.white),
      ),
    );
  }
}

// ─── Latest measurement card ──────────────────────────────────────────────────

class _LatestMeasurementCard extends StatelessWidget {
  const _LatestMeasurementCard();

  @override
  Widget build(BuildContext context) {
    final meas = context.watch<MeasurementProvider>();
    final latest = meas.latest;

    if (latest == null) return const SizedBox.shrink();

    return _GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Latest Reading', style: AppTypography.onDarkLabelLarge),
              const Spacer(),
              Text(
                _formatDate(latest.recordedAt),
                style: AppTypography.onDarkCaption,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            latest.plotName,
            style: AppTypography.onDarkBodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReadingMini(
                  'pH',
                  latest.ph.toStringAsFixed(1),
                  AppColors.phColor,
                ),
              ),
              Expanded(
                child: _ReadingMini(
                  'H₂O',
                  '${latest.moisture.toStringAsFixed(0)}%',
                  AppColors.moistureColor,
                ),
              ),
              Expanded(
                child: _ReadingMini(
                  'N',
                  latest.nitrogen.toStringAsFixed(0),
                  AppColors.nitrogenColor,
                ),
              ),
              Expanded(
                child: _ReadingMini(
                  '°C',
                  latest.temperature.toStringAsFixed(0),
                  AppColors.temperatureColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ReadingMini extends StatelessWidget {
  const _ReadingMini(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.onDarkHeadingSmall
              .copyWith(color: color, fontSize: 16),
        ),
        Text(label, style: AppTypography.onDarkCaption),
      ],
    );
  }
}

//  Plots summary strip

class _PlotsSummaryStrip extends StatelessWidget {
  const _PlotsSummaryStrip();

  @override
  Widget build(BuildContext context) {
    final plotProv = context.watch<PlotProvider>();
    final measProv = context.watch<MeasurementProvider>();
    final plots = plotProv.plots;

    if (plots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('My Plots', style: AppTypography.onDarkHeadingSmall),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: plots.length,
            separatorBuilder: (_, i) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final plot = plots[i];
              final count = measProv.forPlot(plot.id).length;
              return _PlotStripCard(
                plot: plot,
                measurementCount: count,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlotDetailScreen(plotId: plot.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlotStripCard extends StatelessWidget {
  const _PlotStripCard({
    required this.plot,
    required this.measurementCount,
    required this.onTap,
  });
  final PlotModel plot;
  final int measurementCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassContainer(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.grass_rounded, color: AppColors.white, size: 20),
            const Spacer(),
            Text(
              plot.name,
              style: AppTypography.onDarkLabelLarge.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$measurementCount readings',
              style: AppTypography.onDarkCaption,
            ),
          ],
        ),
      ),
    );
  }
}

// Recent activity 

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) {
    final recent = context.watch<MeasurementProvider>().recentFive;
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('Recent Activity', style: AppTypography.onDarkHeadingSmall),
        ),
        _GlassContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: recent.asMap().entries.map((e) {
              final m = e.value;
              final isLast = e.key == recent.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.glass30,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.science_rounded,
                              color: AppColors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.plotName,
                                style: AppTypography.onDarkLabelLarge
                                    .copyWith(fontSize: 13),
                              ),
                              Text(
                                'pH ${m.ph.toStringAsFixed(1)}  ·  H₂O ${m.moisture.toStringAsFixed(0)}%  ·  T ${m.temperature.toStringAsFixed(0)}°C',
                                style: AppTypography.onDarkCaption,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _timeAgo(m.recordedAt),
                          style: AppTypography.onDarkCaption,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: AppColors.glass20,
                      indent: 14,
                      endIndent: 14,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

//  Quick actions grid 

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavigationProvider>();

    final actions = [
      _ActionData(
        icon: Icons.add_location_alt_rounded,
        title: 'Add Plot',
        subtitle: 'Register new land',
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const AddPlotScreen())),
      ),
      _ActionData(
        icon: Icons.add_chart_rounded,
        title: 'Add\nMeasurement',
        subtitle: 'Manual entry',
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddMeasurementScreen())),
      ),
      _ActionData(
        icon: Icons.bluetooth_rounded,
        title: 'Connect\nSensor',
        subtitle: 'Bluetooth pairing',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const SensorScreen(mode: SensorMode.connect))),
      ),
      _ActionData(
        icon: Icons.sensors_rounded,
        title: 'Live\nReading',
        subtitle: 'Start sensor',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const SensorScreen(mode: SensorMode.measure))),
      ),
      _ActionData(
        icon: Icons.bar_chart_rounded,
        title: 'Reports',
        subtitle: 'View analytics',
        onTap: () => nav.switchTab(3),
      ),
      _ActionData(
        icon: Icons.settings_rounded,
        title: 'Settings',
        subtitle: 'App preferences',
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('Quick Actions', style: AppTypography.onDarkHeadingSmall),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemCount: actions.length,
          itemBuilder: (context, i) => _ActionCard(data: actions[i]),
        ),
      ],
    );
  }
}

class _ActionData {
  const _ActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.data});
  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: data.onTap,
            splashColor: AppColors.glass20,
            highlightColor: AppColors.glass10,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.glass20,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.glass30, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.glass30,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(data.icon, color: AppColors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(data.title, style: AppTypography.onDarkLabelLarge,
                      maxLines: 2),
                  const SizedBox(height: 3),
                  Text(data.subtitle, style: AppTypography.onDarkCaption,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Analytics section ────────────────────────────────────────────────────────

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection();

  @override
  Widget build(BuildContext context) {
    final count = context.select<MeasurementProvider, int>((p) => p.count);
    if (count < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('Analytics', style: AppTypography.onDarkHeadingSmall),
        ),
        const SoilHealthTrendChart(),
        const SizedBox(height: 12),
        const NutrientComparisonChart(),
        const SizedBox(height: 12),
        const MonthlyMeasurementChart(),
      ],
    );
  }
}

// ─── Shared glass primitives

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({
    required this.child,
    this.padding,
    this.width,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glass20,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glass30, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  const _GlassIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glass20,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glass30),
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
