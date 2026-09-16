import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import 'chart_data_models.dart';

class AppDonutChart extends StatefulWidget {
  final List<PieSliceDataModel> slices;
  final String? title;
  final String? centerLabel;
  final String? centerValue;
  final double height;
  final double radius;
  final double centerSpaceRadius;
  final bool showLegend;

  const AppDonutChart({
    super.key,
    required this.slices,
    this.title,
    this.centerLabel,
    this.centerValue,
    this.height = 220,
    this.radius = 28,
    this.centerSpaceRadius = 45,
    this.showLegend = true,
  });

  @override
  State<AppDonutChart> createState() => _AppDonutChartState();
}

class _AppDonutChartState extends State<AppDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.slices.fold<double>(0, (sum, item) => sum + item.value);

    if (widget.slices.isEmpty || total <= 0) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('No data for chart')),
      );
    }

    final sections = List.generate(widget.slices.length, (i) {
      final isTouched = i == touchedIndex;
      final slice = widget.slices[i];
      final currentRadius = isTouched ? widget.radius + 6 : widget.radius;

      return PieChartSectionData(
        color: slice.color,
        value: slice.value,
        title: '',
        radius: currentRadius,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
        ],
        SizedBox(
          height: widget.height,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: widget.centerSpaceRadius,
                        sections: sections,
                      ),
                    ),
                    if (widget.centerValue != null || widget.centerLabel != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.centerValue != null)
                            Text(
                              widget.centerValue!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (widget.centerLabel != null)
                            Text(
                              widget.centerLabel!,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              if (widget.showLegend)
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.slices.map((slice) {
                        final pct = total > 0 ? (slice.value / total * 100).toStringAsFixed(0) : '0';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: slice.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  slice.label,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                slice.displayValue ?? '$pct%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
