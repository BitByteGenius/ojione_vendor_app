import 'package:flutter/material.dart';
import '../../../shared/enums/service_type.dart';

class ServiceQuickStat {
  final String label;
  final String value;

  const ServiceQuickStat({
    required this.label,
    required this.value,
  });
}

class VendorActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final ServiceType service;

  const VendorActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    required this.service,
  });
}

class VendorHomeSummary {
  final double settledBalance;
  final double nextSettlement;
  final String settlementCycle;
  final Map<ServiceType, List<ServiceQuickStat>> serviceStats;
  final List<VendorActivityItem> activities;

  const VendorHomeSummary({
    required this.settledBalance,
    required this.nextSettlement,
    required this.settlementCycle,
    required this.serviceStats,
    required this.activities,
  });
}
