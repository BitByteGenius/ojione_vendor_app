import 'package:flutter/material.dart';

class ChartDataPoint {
  final double x;
  final double y;
  final String label;

  const ChartDataPoint({
    required this.x,
    required this.y,
    required this.label,
  });
}

class BarGroupDataModel {
  final int x;
  final String label;
  final double value;
  final double? secondaryValue;

  const BarGroupDataModel({
    required this.x,
    required this.label,
    required this.value,
    this.secondaryValue,
  });
}

class PieSliceDataModel {
  final String label;
  final double value;
  final Color color;
  final String? displayValue;

  const PieSliceDataModel({
    required this.label,
    required this.value,
    required this.color,
    this.displayValue,
  });
}
