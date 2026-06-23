import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/measurement_provider.dart';
import 'chart_shared.dart';

class MonthlyMeasurementChart extends StatelessWidget {
  const MonthlyMeasurementChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.select<MeasurementProvider, Map<String, int>>(
      (p) => p.monthlyCountData,
    );

    final hasData = data.values.any((v) => v > 0);

    return ChartCard(
      title: 'Monthly Readings',
      subtitle: 'Measurements recorded per month',
      child: !hasData
          ? const ChartEmptyState('No measurements in the last 6 months')
          : SizedBox(
              height: 140,
              child: BarChart(
                _buildData(data),
                duration: const Duration(milliseconds: 400),
              ),
            ),
    );
  }

  BarChartData _buildData(Map<String, int> data) {
    final entries = data.entries.toList();
    final maxRaw =
        entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final maxY = (maxRaw + 1).toDouble();

    final groups = entries.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.value.toDouble(),
            gradient: const LinearGradient(
              colors: [AppColors.primaryMid, AppColors.primaryLight],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 24,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: AppColors.glass10,
            ),
          ),
        ],
      );
    }).toList();

    return BarChartData(
      barGroups: groups,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.glass20,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 1,
            getTitlesWidget: (value, _) {
              if (value != value.roundToDouble()) {
                return const SizedBox.shrink();
              }
              return Text(
                value.toInt().toString(),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textOnDarkSecondary,
                  fontSize: 9,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: (value, _) {
              final idx = value.toInt();
              if (idx < 0 || idx >= entries.length) {
                return const SizedBox.shrink();
              }
              return Text(
                entries[idx].key.split(' ').first,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textOnDarkSecondary,
                  fontSize: 9,
                ),
              );
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, _, rod, _) {
            final entry = entries[group.x];
            return BarTooltipItem(
              '${entry.key}\n${entry.value} reading${entry.value == 1 ? '' : 's'}',
              AppTypography.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
    );
  }
}
