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
      return Container(
        width: isCollapsed ? AppDimensions.sidebarWidthCollapsed : AppDimensions.sidebarWidthExpanded,
        decoration: const BoxDecoration(
          color: AppColors.sidebarDark,
          border: Border(right: BorderSide(color: Color(0xFF1F2937), width: 1)),
        ),
        child: Column(
          children: [
            // Brand Logo & Title Header
            _buildHeader(),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSm,
                  vertical: AppDimensions.spaceMd,
                ),
                children: [
                  // Core: Dashboard
                  _buildNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    route: '/dashboard',
                    isSelected: currentRoute == '/dashboard' || currentRoute == '/',
                  ),

                  // Central Bookings
                  _buildNavItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Central Bookings',
                    route: '/bookings',
                    isSelected: currentRoute.startsWith('/bookings'),
                  ),

                  // Earnings
                  _buildNavItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Earnings & Payouts',
                    route: '/earnings',
                    isSelected: currentRoute.startsWith('/earnings'),
                  ),

                  const SizedBox(height: AppDimensions.spaceMd),
                  if (!isCollapsed) _buildSectionHeader('ASSIGNED SERVICES'),

                  // Dynamic Services (Only shown if enabled for vendor)
                  if (auth.hasService(ServiceType.stay))
                    _buildNavItem(
                      icon: ServiceType.stay.icon,
                      label: ServiceType.stay.displayName,
                      route: ServiceType.stay.routePath,
                      isSelected: currentRoute.startsWith('/stay'),
                      accentColor: ServiceType.stay.color,
                    ),

                  if (auth.hasService(ServiceType.trips))
                    _buildNavItem(
                      icon: ServiceType.trips.icon,
                      label: ServiceType.trips.displayName,
                      route: ServiceType.trips.routePath,
                      isSelected: currentRoute.startsWith('/trips'),
                      accentColor: ServiceType.trips.color,
                    ),

                  if (auth.hasService(ServiceType.shop))
                    _buildNavItem(
                      icon: ServiceType.shop.icon,
                      label: ServiceType.shop.displayName,
                      route: ServiceType.shop.routePath,
                      isSelected: currentRoute.startsWith('/shop'),
                      accentColor: ServiceType.shop.color,
                    ),

                  if (auth.hasService(ServiceType.rental))
                    _buildNavItem(
                      icon: ServiceType.rental.icon,
                      label: ServiceType.rental.displayName,
                      route: ServiceType.rental.routePath,
                      isSelected: currentRoute.startsWith('/rental'),
                      accentColor: ServiceType.rental.color,
                    ),

                  if (auth.hasService(ServiceType.localExperiences))
                    _buildNavItem(
                      icon: ServiceType.localExperiences.icon,
                      label: ServiceType.localExperiences.displayName,
                      route: ServiceType.localExperiences.routePath,
                      isSelected: currentRoute.startsWith('/experiences'),
                      accentColor: ServiceType.localExperiences.color,
                    ),

                  const SizedBox(height: AppDimensions.spaceMd),
                  if (!isCollapsed) _buildSectionHeader('MANAGEMENT'),

                  _buildNavItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    route: '/notifications',
                    isSelected: currentRoute.startsWith('/notifications'),
                  ),

                  _buildNavItem(
                    icon: Icons.badge_outlined,
                    label: 'Vendor Profile',
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

            // Bottom collapse button / User chip
            _buildFooter(),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      height: AppDimensions.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.primary,
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Vendor Panel',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryLight.withAlpha(200),
                    ),
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
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
            vertical: AppDimensions.spaceSm + 2,
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
                size: 20,
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
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
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
              child: Obx(() => Text(
                    AuthService.to.currentRole.value.label,
                    style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  )),
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
