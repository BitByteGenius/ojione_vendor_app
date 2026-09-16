import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../enums/service_type.dart';

class AppSidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AppSidebar({
    super.key,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final auth = AuthService.to;

    return Obx(() {
      final assigned = auth.assignedServices;

      return Container(
        width: isCollapsed ? AppDimensions.sidebarWidthCollapsed : AppDimensions.sidebarWidthExpanded,
        decoration: const BoxDecoration(
          color: AppColors.sidebarDark,
          border: Border(right: BorderSide(color: Color(0xFF1F2937), width: 1)),
        ),
        child: Column(
          children: [
            // Brand Logo & Vendor Status Header
            _buildHeader(auth),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSm,
                  vertical: AppDimensions.spaceMd,
                ),
                children: [
                  // Core Vendor Section
                  if (!isCollapsed) _buildSectionHeader('CORE ACCOUNT'),

                  _buildNavItem(
                    icon: Icons.storefront_rounded,
                    label: 'Vendor Core Dashboard',
                    route: '/dashboard',
                    isSelected: currentRoute == '/dashboard' || currentRoute == '/',
                  ),

                  const SizedBox(height: AppDimensions.spaceMd),

                  // STRICT DYNAMIC SERVICE ISOLATION
                  // Only services present in assignedServices are displayed!
                  if (!isCollapsed)
                    _buildSectionHeader(
                      'ASSIGNED SERVICES (${assigned.length})',
                    ),

                  if (assigned.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceMd,
                        vertical: AppDimensions.spaceSm,
                      ),
                      child: Text(
                        'No services assigned.',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ),

                  // 1. Stay (Rendered ONLY if vendor selected Stay)
                  if (auth.hasService(ServiceType.stay)) ...[
                    _buildNavItem(
                      icon: ServiceType.stay.icon,
                      label: 'Stay Dashboard',
                      route: ServiceType.stay.routePath,
                      isSelected: currentRoute == '/stay',
                      accentColor: ServiceType.stay.color,
                      badgeText: 'Live',
                    ),
                    if (!isCollapsed && currentRoute.startsWith('/stay')) ...[
                      _buildSubNavItem('All Properties', '/stay/properties', currentRoute == '/stay/properties'),
                      _buildSubNavItem('Rooms & Units', '/stay/rooms', currentRoute == '/stay/rooms'),
                      _buildSubNavItem('Availability Calendar', '/stay/availability', currentRoute == '/stay/availability'),
                      _buildSubNavItem('Pricing & Tariffs', '/stay/pricing', currentRoute == '/stay/pricing'),
                    ],
                  ],

                  // 2. Tours & Trips (Rendered ONLY if vendor selected Trips)
                  if (auth.hasService(ServiceType.trips)) ...[
                    _buildNavItem(
                      icon: ServiceType.trips.icon,
                      label: 'Tours & Trips',
                      route: ServiceType.trips.routePath,
                      isSelected: currentRoute == '/trips',
                      accentColor: ServiceType.trips.color,
                      badgeText: 'Live',
                    ),
                    if (!isCollapsed && currentRoute.startsWith('/trips')) ...[
                      _buildSubNavItem('Tour Packages', '/trips/packages', currentRoute == '/trips/packages'),
                      _buildSubNavItem('Destinations', '/trips/destinations', currentRoute == '/trips/destinations'),
                      _buildSubNavItem('Day Itineraries', '/trips/itinerary', currentRoute == '/trips/itinerary'),
                    ],
                  ],

                  // 3. Shop (Rendered ONLY if vendor selected Shop)
                  if (auth.hasService(ServiceType.shop)) ...[
                    _buildNavItem(
                      icon: ServiceType.shop.icon,
                      label: 'Shop Dashboard',
                      route: ServiceType.shop.routePath,
                      isSelected: currentRoute == '/shop',
                      accentColor: ServiceType.shop.color,
                      badgeText: 'Live',
                    ),
                    if (!isCollapsed && currentRoute.startsWith('/shop')) ...[
                      _buildSubNavItem('Products Catalog', '/shop/products', currentRoute == '/shop/products'),
                      _buildSubNavItem('Inventory Stock', '/shop/inventory', currentRoute == '/shop/inventory'),
                      _buildSubNavItem('Orders & Dispatch', '/shop/orders', currentRoute == '/shop/orders'),
                    ],
                  ],

                  // 4. Vehicle Rental (Rendered ONLY if vendor selected Rental)
                  if (auth.hasService(ServiceType.rental)) ...[
                    _buildNavItem(
                      icon: ServiceType.rental.icon,
                      label: 'Vehicle Rental',
                      route: ServiceType.rental.routePath,
                      isSelected: currentRoute == '/rental',
                      accentColor: ServiceType.rental.color,
                      badgeText: 'Live',
                    ),
                    if (!isCollapsed && currentRoute.startsWith('/rental')) ...[
                      _buildSubNavItem('Fleet Vehicles', '/rental/vehicles', currentRoute == '/rental/vehicles'),
                      _buildSubNavItem('Availability', '/rental/availability', currentRoute == '/rental/availability'),
                      _buildSubNavItem('Tariffs & Deposit', '/rental/pricing', currentRoute == '/rental/pricing'),
                    ],
                  ],

                  // 5. Local Experiences (Rendered ONLY if vendor selected Local Experiences)
                  if (auth.hasService(ServiceType.localExperiences)) ...[
                    _buildNavItem(
                      icon: ServiceType.localExperiences.icon,
                      label: 'Local Experiences',
                      route: ServiceType.localExperiences.routePath,
                      isSelected: currentRoute == '/experiences',
                      accentColor: ServiceType.localExperiences.color,
                      badgeText: 'Live',
                    ),
                    if (!isCollapsed && currentRoute.startsWith('/experiences')) ...[
                      _buildSubNavItem('Experiences List', '/experiences/list', currentRoute == '/experiences/list'),
                      _buildSubNavItem('Schedule & Slots', '/experiences/schedule', currentRoute == '/experiences/schedule'),
                    ],
                  ],

                  const SizedBox(height: AppDimensions.spaceMd),

                  // GENERAL OPERATIONS
                  if (!isCollapsed) _buildSectionHeader('OPERATIONS & ADMIN'),

                  _buildNavItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Central Bookings',
                    route: '/bookings',
                    isSelected: currentRoute.startsWith('/bookings'),
                  ),

                  _buildNavItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Earnings & Payouts',
                    route: '/earnings',
                    isSelected: currentRoute.startsWith('/earnings'),
                  ),

                  _buildNavItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    route: '/notifications',
                    isSelected: currentRoute.startsWith('/notifications'),
                  ),

                  _buildNavItem(
                    icon: Icons.badge_outlined,
                    label: 'Vendor Profile & KYC',
                    route: '/profile',
                    isSelected: currentRoute.startsWith('/profile'),
                  ),

                  _buildNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    route: '/settings',
                    isSelected: currentRoute.startsWith('/settings'),
                  ),
                ],
              ),
            ),

            // Bottom user info / collapse button
            _buildFooter(auth),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(AuthService auth) {
    return Container(
      height: AppDimensions.topBarHeight + 10,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryHover],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: AppDimensions.spaceSm + 2),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SewaSetu',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: auth.verificationStatus.value.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          auth.verificationStatus.value.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: auth.verificationStatus.value.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceXs,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
    Color? accentColor,
    String? badgeText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          if (Get.currentRoute != route) {
            Get.toNamed(route);
          }
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppDimensions.spaceSm : AppDimensions.spaceMd,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.sidebarActive : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 19,
                color: isSelected
                    ? Colors.white
                    : (accentColor ?? const Color(0xFF9CA3AF)),
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badgeText != null && !isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (accentColor ?? AppColors.primary).withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: accentColor ?? AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubNavItem(String label, String route, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, top: 1, bottom: 1),
      child: InkWell(
        onTap: () {
          if (Get.currentRoute != route) {
            Get.toNamed(route);
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1F2937) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AuthService auth) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceSm),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (!isCollapsed)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    auth.ownerName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    auth.vendorName.value,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          if (onToggleCollapse != null)
            IconButton(
              icon: Icon(
                isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                color: const Color(0xFF9CA3AF),
                size: 20,
              ),
              onPressed: onToggleCollapse,
              tooltip: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
            ),
        ],
      ),
    );
  }
}
