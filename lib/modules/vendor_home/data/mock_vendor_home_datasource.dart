import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/enums/service_type.dart';
import '../models/vendor_home_data_model.dart';
import 'vendor_home_datasource.dart';

class MockVendorHomeDataSource implements VendorHomeDataSource {
  static const Map<ServiceType, List<ServiceQuickStat>> _allServiceStats = {
    ServiceType.stay: [
      ServiceQuickStat(label: 'Active Properties', value: '4 Units'),
      ServiceQuickStat(label: 'Occupancy', value: '87%'),
    ],
    ServiceType.rental: [
      ServiceQuickStat(label: 'Fleet Size', value: '8 Vehicles'),
      ServiceQuickStat(label: 'Available', value: '6 Ready'),
    ],
    ServiceType.shop: [
      ServiceQuickStat(label: 'Total Products', value: '24 Items'),
      ServiceQuickStat(label: 'Pending Orders', value: '5 Orders'),
    ],
    ServiceType.trips: [
      ServiceQuickStat(label: 'Active Packages', value: '6 Tours'),
      ServiceQuickStat(label: 'Upcoming Trips', value: '9 Groups'),
    ],
    ServiceType.localExperiences: [
      ServiceQuickStat(label: 'Experiences', value: '5 Active'),
      ServiceQuickStat(label: 'Participants', value: '48 This Wk'),
    ],
  };

  static const List<VendorActivityItem> _allActivities = [
    VendorActivityItem(
      title: 'New Booking Confirmed',
      description: 'Brahmaputra View Deluxe Room #204 • 2 Guests (3 Nights)',
      time: '12m ago',
      icon: Icons.hotel_rounded,
      color: AppColors.stayService,
      service: ServiceType.stay,
    ),
    VendorActivityItem(
      title: 'Vehicle Rental Scheduled',
      description: 'Mahindra Thar 4x4 (AS-01-EC-9902) • Pickup at Airport',
      time: '45m ago',
      icon: Icons.directions_car_rounded,
      color: AppColors.rentalService,
      service: ServiceType.rental,
    ),
    VendorActivityItem(
      title: 'Muga Silk Saree Order Dispatched',
      description: 'Order #ORD-7819 • Shipped via Indian Post Speed Service',
      time: '2h ago',
      icon: Icons.shopping_bag_rounded,
      color: AppColors.shopService,
      service: ServiceType.shop,
    ),
    VendorActivityItem(
      title: 'Kaziranga Safari Group Booked',
      description: 'Eastern Range Jeep Safari • 4 Seats Confirmed for Saturday',
      time: '3h ago',
      icon: Icons.hiking_rounded,
      color: AppColors.tripsService,
      service: ServiceType.trips,
    ),
    VendorActivityItem(
      title: 'Assam Tea Tasting Workshop Reserved',
      description: 'Batch 10:00 AM • 6 Participants Registered',
      time: '5h ago',
      icon: Icons.local_activity_rounded,
      color: AppColors.localExpService,
      service: ServiceType.localExperiences,
    ),
  ];

  @override
  Future<VendorHomeSummary> getHomeSummary({required List<ServiceType> assignedServices}) async {
    // Simulate slight async network/database delay
    await Future.delayed(const Duration(milliseconds: 150));

    // Dynamic balance calculations based on enabled services
    double baseSettled = 0.0;
    double baseNext = 0.0;

    for (final service in assignedServices) {
      switch (service) {
        case ServiceType.stay:
          baseSettled += 85000.0;
          baseNext += 18200.0;
          break;
        case ServiceType.rental:
          baseSettled += 63500.0;
          baseNext += 16000.0;
          break;
        case ServiceType.shop:
          baseSettled += 42800.0;
          baseNext += 11500.0;
          break;
        case ServiceType.trips:
          baseSettled += 74000.0;
          baseNext += 22400.0;
          break;
        case ServiceType.localExperiences:
          baseSettled += 29500.0;
          baseNext += 7800.0;
          break;
      }
    }

    final filteredActivities = _allActivities
        .where((a) => assignedServices.contains(a.service))
        .toList();

    return VendorHomeSummary(
      settledBalance: baseSettled > 0 ? baseSettled : 45000.0,
      nextSettlement: baseNext > 0 ? baseNext : 12000.0,
      settlementCycle: 'Cycle: Friday',
      serviceStats: Map.fromEntries(
        assignedServices.map((s) => MapEntry(s, _allServiceStats[s] ?? [])),
      ),
      activities: filteredActivities,
    );
  }

  @override
  Future<List<VendorActivityItem>> getRecentActivities({required List<ServiceType> assignedServices}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _allActivities
        .where((a) => assignedServices.contains(a.service))
        .toList();
  }

  @override
  Future<List<ServiceQuickStat>> getServiceQuickStats(ServiceType service) async {
    return _allServiceStats[service] ?? const [];
  }
}
