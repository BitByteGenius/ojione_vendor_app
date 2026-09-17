import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';

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

class VendorHomeController extends GetxController {
  final auth = AuthService.to;

  // Bottom navigation tab index
  final currentTabIndex = 0.obs;

  // Refresh indicator
  final isRefreshing = false.obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> refreshHome() async {
    isRefreshing.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isRefreshing.value = false;
  }

  // Filtered recent activities for only assigned services
  List<VendorActivityItem> get activities {
    final assigned = auth.assignedServices;
    final allActivities = <VendorActivityItem>[
      const VendorActivityItem(
        title: 'New Booking Confirmed',
        description: 'Brahmaputra View Deluxe Room #204 • 2 Guests (3 Nights)',
        time: '12m ago',
        icon: Icons.hotel_rounded,
        color: Color(0xFF0D9488),
        service: ServiceType.stay,
      ),
      const VendorActivityItem(
        title: 'Vehicle Rental Scheduled',
        description: 'Mahindra Thar 4x4 (AS-01-EC-9902) • Pickup at Airport',
        time: '45m ago',
        icon: Icons.directions_car_rounded,
        color: Color(0xFFD97706),
        service: ServiceType.rental,
      ),
      const VendorActivityItem(
        title: 'Muga Silk Saree Order Dispatched',
        description: 'Order #ORD-7819 • Shipped via Indian Post Speed Service',
        time: '2h ago',
        icon: Icons.shopping_bag_rounded,
        color: Color(0xFF7C3AED),
        service: ServiceType.shop,
      ),
      const VendorActivityItem(
        title: 'Kaziranga Safari Group Booked',
        description: 'Eastern Range Jeep Safari • 4 Seats Confirmed for Saturday',
        time: '3h ago',
        icon: Icons.hiking_rounded,
        color: Color(0xFF0284C7),
        service: ServiceType.trips,
      ),
      const VendorActivityItem(
        title: 'Assam Tea Tasting Workshop Reserved',
        description: 'Batch 10:00 AM • 6 Participants Registered',
        time: '5h ago',
        icon: Icons.local_activity_rounded,
        color: Color(0xFFE11D48),
        service: ServiceType.localExperiences,
      ),
    ];

    return allActivities.where((a) => assigned.contains(a.service)).toList();
  }

  void openServiceDashboard(ServiceType service) {
    auth.setActiveService(service);
    Get.toNamed(service.routePath);
  }
}
