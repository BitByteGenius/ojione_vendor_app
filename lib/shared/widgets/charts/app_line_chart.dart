import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'chart_data_models.dart';

class AppLineChart extends StatelessWidget {
  final List<ChartDataPoint> dataPoints;
  final String? title;
  final String? subtitle;
  final Color primaryColor;
  final bool showArea;
  final String Function(double)? valueFormatter;
  final double height;

  const AppLineChart({
    super.key,
    required this.dataPoints,
    this.title,
    this.subtitle,
    this.primaryColor = AppColors.primary,
    this.showArea = true,
    this.valueFormatter,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    if (dataPoints.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No chart data available')),
      );
    }

    final spots = dataPoints.map((e) => FlSpot(e.x, e.y)).toList();
    final maxY = dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minY = dataPoints.map((e) => e.y).reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 12, color: textColor),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
        ],
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((barSpot) {
                      final point = dataPoints.firstWhere(
                        (p) => p.x == barSpot.x,
                        orElse: () => ChartDataPoint(x: barSpot.x, y: barSpot.y, label: ''),
                      );
                      final formattedVal = valueFormatter != null
                          ? valueFormatter!(barSpot.y)
                          : barSpot.y.toStringAsFixed(0);
                      return LineTooltipItem(
                        '${point.label.isNotEmpty ? "${point.label}\n" : ""}$formattedVal',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (maxY - minY) > 0 ? (maxY - minY) / 4 : 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: gridColor.withAlpha(80),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < dataPoints.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            dataPoints[index].label,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (valueFormatter != null) {
                        text = valueFormatter!(value);
                      } else if (value >= 1000) {
                        text = '${(value / 1000).toStringAsFixed(0)}k';
                      } else {
                        text = value.toStringAsFixed(0);
                      }
                      return Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (dataPoints.length - 1).toDouble(),
              minY: (minY * 0.85).clamp(0, double.infinity),
              maxY: maxY * 1.15,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: primaryColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3.5,
                        color: Colors.white,
                        strokeWidth: 2.5,
                        strokeColor: primaryColor,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: showArea,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withAlpha(80),
                        primaryColor.withAlpha(5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
