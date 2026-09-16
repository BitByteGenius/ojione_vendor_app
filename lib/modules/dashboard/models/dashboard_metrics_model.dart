import '../../../shared/enums/service_type.dart';

class VendorActivityItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final ServiceType? serviceType;
  final String type; // 'kyc', 'booking', 'payout', 'security'

  const VendorActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.serviceType,
    required this.type,
  });

  factory VendorActivityItem.fromJson(Map<String, dynamic> json) {
    return VendorActivityItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] ?? '',
      serviceType: json['service_type'] != null
          ? ServiceType.fromString(json['service_type'])
          : null,
      type: json['type'] ?? 'general',
    );
  }
}

class ServicePortalSummary {
  final ServiceType service;
  final int activeListingsCount;
  final int todayBookingsCount;
  final double monthRevenue;
  final String status;

  const ServicePortalSummary({
    required this.service,
    required this.activeListingsCount,
    required this.todayBookingsCount,
    required this.monthRevenue,
    required this.status,
  });
}

class VendorCoreDashboardModel {
  final double totalEarnings;
  final double pendingPayout;
  final int totalBookingsCount;
  final int activeListingsCount;
  final List<ServicePortalSummary> serviceSummaries;
  final List<VendorActivityItem> recentActivities;

  const VendorCoreDashboardModel({
    required this.totalEarnings,
    required this.pendingPayout,
    required this.totalBookingsCount,
    required this.activeListingsCount,
    required this.serviceSummaries,
    required this.recentActivities,
  });
}
