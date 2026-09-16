import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'chart_data_models.dart';

class AppBarChart extends StatelessWidget {
  final List<BarGroupDataModel> groups;
  final String? title;
  final String? subtitle;
  final Color barColor;
  final Color? secondaryBarColor;
  final String Function(double)? valueFormatter;
  final double height;
  final double barWidth;

  const AppBarChart({
    super.key,
    required this.groups,
    this.title,
    this.subtitle,
    this.barColor = AppColors.primary,
    this.secondaryBarColor,
    this.valueFormatter,
    this.height = 240,
    this.barWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    if (groups.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No chart data available')),
      );
    }

    final maxY = groups.map((g) {
      final v1 = g.value;
      final v2 = g.secondaryValue ?? 0;
      return v1 > v2 ? v1 : v2;
    }).reduce((a, b) => a > b ? a : b);

    final barGroups = groups.map((g) {
      final rods = <BarChartRodData>[
        BarChartRodData(
          toY: g.value,
          color: barColor,
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ];

      if (g.secondaryValue != null && secondaryBarColor != null) {
        rods.add(
          BarChartRodData(
            toY: g.secondaryValue!,
            color: secondaryBarColor!,
            width: barWidth,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        );
      }

      return BarChartGroupData(
        x: g.x,
        barRods: rods,
        barsSpace: 4,
      );
    }).toList();

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
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY * 1.15,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final g = groups.firstWhere(
                      (item) => item.x == group.x,
                      orElse: () => groups[groupIndex],
                    );
                    final formattedVal = valueFormatter != null
                        ? valueFormatter!(rod.toY)
                        : rod.toY.toStringAsFixed(0);
                    return BarTooltipItem(
                      '${g.label}\n$formattedVal',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = groups.indexWhere((g) => g.x == value.toInt());
                      if (index >= 0 && index < groups.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            groups[index].label,
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
                    reservedSize: 42,
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
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: gridColor.withAlpha(80),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
      ],
    );
  }
}
