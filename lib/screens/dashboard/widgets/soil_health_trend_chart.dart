import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/measurement_provider.dart';
import 'chart_shared.dart';

class SoilHealthTrendChart extends StatelessWidget {
  const SoilHealthTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final points = context.select<MeasurementProvider,
        List<({double x, double y, DateTime date})>>(
      (p) => p.healthTrendPoints,
    );

    return ChartCard(
      title: 'Soil Health Trend',
      subtitle: 'Score per reading (0–100)',
      child: points.length < 2
          ? const ChartEmptyState('Add at least 2 readings to see the trend')
          : SizedBox(
              height: 160,
              child: LineChart(
                _buildData(points),
                duration: const Duration(milliseconds: 400),
              ),
            ),
    );
  }

  LineChartData _buildData(
      List<({double x, double y, DateTime date})> points) {
    final spots = points.map((p) => FlSpot(p.x, p.y)).toList();

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.primaryLight,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, _, barData, index) => FlDotCirclePainter(
              radius: 3.5,
              color: _scoreColor(spot.y),
              strokeWidth: 1.5,
              strokeColor: AppColors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryLight.withValues(alpha: 0.25),
                AppColors.primaryLight.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
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
            reservedSize: 32,
            interval: 25,
            getTitlesWidget: (value, _) => Text(
              '${value.toInt()}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textOnDarkSecondary,
                fontSize: 9,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: (value, _) {
              final idx = value.toInt();
              if (idx < 0 || idx >= points.length) {
                return const SizedBox.shrink();
              }
              if (idx != 0 &&
                  idx != points.length - 1 &&
                  idx != points.length ~/ 2) {
                return const SizedBox.shrink();
              }
              final dt = points[idx].date;
              return Text(
                '${dt.day}/${dt.month}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textOnDarkSecondary,
                  fontSize: 9,
                ),
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    '${s.y.toStringAsFixed(0)}%',
                    AppTypography.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 70) return AppColors.success;
    if (score >= 40) return AppColors.warning;
    return AppColors.danger;
  }
}
