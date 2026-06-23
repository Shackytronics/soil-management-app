import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/measurement_provider.dart';
import 'chart_shared.dart';

class NutrientComparisonChart extends StatelessWidget {
  const NutrientComparisonChart({super.key});

  static const _labels = ['N', 'P', 'K', 'pH', 'H₂O', 'Temp', 'EC'];
  static const _colors = [
    AppColors.nitrogenColor,
    AppColors.phosphorusColor,
    AppColors.potassiumColor,
    AppColors.phColor,
    AppColors.moistureColor,
    AppColors.temperatureColor,
    AppColors.conductivityColor,
  ];

  @override
  Widget build(BuildContext context) {
    final scores =
        context.select<MeasurementProvider, Map<String, double>>(
      (p) => p.nutrientScores,
    );

    return ChartCard(
      title: 'Nutrient Status',
      subtitle: 'Optimal score per parameter (0–100)',
      child: scores.isEmpty
          ? const ChartEmptyState('No measurements yet')
          : SizedBox(
              height: 160,
              child: BarChart(
                _buildData(scores),
                duration: const Duration(milliseconds: 400),
              ),
            ),
    );
  }

  BarChartData _buildData(Map<String, double> scores) {
    final groups = _labels.asMap().entries.map((e) {
      final value = scores[e.value] ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: value,
            color: _colors[e.key],
            width: 22,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: AppColors.glass10,
            ),
          ),
        ],
      );
    }).toList();

    return BarChartData(
      barGroups: groups,
      maxY: 100,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, _) {
              final idx = value.toInt();
              if (idx < 0 || idx >= _labels.length) {
                return const SizedBox.shrink();
              }
              return Text(
                _labels[idx],
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
          getTooltipItem: (group, _, rod, _) => BarTooltipItem(
            '${_labels[group.x]}\n${rod.toY.toStringAsFixed(0)}%',
            AppTypography.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
