import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/mobile_app_bar.dart';
import '../../../shared/widgets/mobile_bottom_nav_bar.dart';
import '../../bookings/screens/bookings_screen.dart';
import '../../earnings/screens/earnings_screen.dart';
import '../../local_experiences/screens/experiences_dashboard_screen.dart';
import '../../rental/screens/rental_dashboard_screen.dart';
import '../../shop/screens/shop_dashboard_screen.dart';
import '../../stay/screens/stay_dashboard_screen.dart';
import '../../trips/screens/trips_dashboard_screen.dart';
import '../../vendor_profile/screens/profile_screen.dart';
import '../controllers/vendor_home_controller.dart';
import '../widgets/demo_vendor_switcher_modal.dart';
import 'services_hub_screen.dart';
import 'vendor_home_screen.dart';

class VendorShellScreen extends GetView<VendorHomeController> {
  const VendorShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return Obx(() {
      final assigned = auth.assignedServices.toList();
      final hasSingleService = assigned.length == 1;
      final singleService = hasSingleService ? assigned.first : null;

      // Construct pages according to single vs multi service assignment
      final pages = <Widget>[
        const VendorHomeScreen(),
      ];

      if (hasSingleService && singleService != null) {
        // Tab 1: Dedicated Dashboard for that single service
        pages.add(_buildSingleServiceDashboard(singleService));
        // Tab 2: Bookings / Orders
        pages.add(const BookingsScreen());
      } else {
        // Tab 1: Services Hub (Stay, Rental, etc.)
        pages.add(const ServicesHubScreen());
        // Tab 2: Combined Bookings for assigned services
        pages.add(const BookingsScreen());
      }

      // Tab 3: Earnings
      pages.add(const EarningsScreen());

      // Tab 4: Profile
      pages.add(const ProfileScreen());

      // Guard tab index out of bounds when switching profiles
      final activeIndex = controller.currentTabIndex.value >= pages.length
          ? 0
          : controller.currentTabIndex.value;

      return Scaffold(
        appBar: MobileAppBar(
          title: _getAppBarTitle(activeIndex, hasSingleService, singleService),
          subtitle: activeIndex == 0 ? auth.vendorName.value : null,
          showVendorBadge: activeIndex == 0,
          showNotificationBell: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.swap_horiz_rounded, size: 22),
              tooltip: 'Demo Profile Switcher',
              onPressed: () => DemoVendorSwitcherModal.show(context),
            ),
          ],
        ),
        body: IndexedStack(
          index: activeIndex,
          children: pages,
        ),
        bottomNavigationBar: MobileBottomNavBar(
          currentIndex: activeIndex,
          onTap: controller.changeTab,
          assignedServices: assigned,
        ),
      );
    });
  }

  Widget _buildSingleServiceDashboard(ServiceType service) {
    switch (service) {
      case ServiceType.stay:
        return const StayDashboardScreen();
      case ServiceType.trips:
        return const TripsDashboardScreen();
      case ServiceType.shop:
        return const ShopDashboardScreen();
      case ServiceType.rental:
        return const RentalDashboardScreen();
      case ServiceType.localExperiences:
        return const ExperiencesDashboardScreen();
    }
  }

  String _getAppBarTitle(int index, bool hasSingleService, ServiceType? singleService) {
    if (index == 0) return 'SewaSetu Vendor';
    if (index == 1) {
      return hasSingleService && singleService != null
          ? singleService.displayName
          : 'My Services';
    }
    if (index == 2) {
      return hasSingleService && singleService == ServiceType.shop
          ? 'Store Orders'
          : 'Bookings & Reservations';
    }
    if (index == 3) return 'Earnings & Financials';
    return 'Vendor Account';
  }
}
