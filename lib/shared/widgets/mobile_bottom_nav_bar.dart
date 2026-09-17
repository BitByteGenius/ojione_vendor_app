import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../shared/enums/service_type.dart';

class MobileNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const MobileNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

class MobileBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<ServiceType> assignedServices;

  const MobileBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.assignedServices,
  });

  List<MobileNavItem> get items {
    final hasSingleService = assignedServices.length == 1;
    final singleService = hasSingleService ? assignedServices.first : null;

    final navItems = <MobileNavItem>[
      const MobileNavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        route: '/vendor-home',
      ),
    ];

    if (hasSingleService && singleService != null) {
      // Single service adaptive tab (e.g. Shop, Stay, Rental, Trips, Experiences)
      navItems.add(MobileNavItem(
        label: singleService.displayName,
        icon: singleService.icon,
        activeIcon: singleService.icon,
        route: singleService.routePath,
      ));

      // If shop, label is 'Orders', otherwise 'Bookings'
      final bookingsLabel = singleService == ServiceType.shop ? 'Orders' : 'Bookings';
      final bookingsIcon = singleService == ServiceType.shop
          ? Icons.shopping_bag_outlined
          : Icons.calendar_today_outlined;
      final bookingsActiveIcon = singleService == ServiceType.shop
          ? Icons.shopping_bag_rounded
          : Icons.calendar_today_rounded;

      navItems.add(MobileNavItem(
        label: bookingsLabel,
        icon: bookingsIcon,
        activeIcon: bookingsActiveIcon,
        route: '/bookings',
      ));
    } else {
      // Multiple services: 'Services' hub tab + 'Bookings' tab
      navItems.add(const MobileNavItem(
        label: 'Services',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        route: '/services-hub',
      ));

      navItems.add(const MobileNavItem(
        label: 'Bookings',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded,
        route: '/bookings',
      ));
    }

    navItems.add(const MobileNavItem(
      label: 'Earnings',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      route: '/earnings',
    ));

    navItems.add(const MobileNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: '/profile',
    ));

    return navItems;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = items;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    onTap: () => onTap(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withAlpha(25)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 22,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
