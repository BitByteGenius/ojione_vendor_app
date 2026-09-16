import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../enums/service_type.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onMenuPressed;

  const AppTopBar({
    super.key,
    required this.title,
    this.trailing,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = AuthService.to;

    return Container(
      height: AppDimensions.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (onMenuPressed != null) ...[
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: onMenuPressed,
              tooltip: 'Open menu',
            ),
            const SizedBox(width: AppDimensions.spaceSm),
          ],
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppDimensions.spaceSm),
                  trailing!,
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSm),

          // Active Service Quick-Jump Selector (Shows only assigned services)
          Obx(() {
            final services = auth.assignedServices.toList();
            if (services.isEmpty) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Service:',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<ServiceType>(
                    tooltip: 'Switch Service Dashboard',
                    onSelected: (srv) {
                      auth.setActiveService(srv);
                      Get.toNamed(srv.routePath);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          auth.activeService.value?.icon ?? Icons.hub_rounded,
                          size: 15,
                          color: auth.activeService.value?.color ?? AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          auth.activeService.value?.displayName ?? 'Select Service',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: auth.activeService.value?.color ?? AppColors.primary,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_rounded, size: 18),
                      ],
                    ),
                    itemBuilder: (context) {
                      return services.map((s) {
                        return PopupMenuItem(
                          value: s,
                          child: Row(
                            children: [
                              Icon(s.icon, size: 16, color: s.color),
                              const SizedBox(width: 8),
                              Text(s.displayName),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            );
          }),

          const SizedBox(width: AppDimensions.spaceSm),

          // Demo Vendor Switcher Button (Allows fast testing of strict service separation)
          PopupMenuButton<String>(
            tooltip: 'Switch Demo Vendor Profile (Test Service Isolation)',
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primary.withAlpha(80)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Demo Profiles',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: 16, color: AppColors.primary),
                ],
              ),
            ),
            onSelected: (val) {
              if (val == 'demo_a') {
                auth.setDemoVendorAStayRental();
                Get.offAllNamed('/dashboard');
                Get.snackbar('Vendor Profile Loaded', 'Vendor A: Stay + Vehicle Rental (Shop, Trips, Experiences hidden)');
              } else if (val == 'demo_b') {
                auth.setDemoVendorBShopOnly();
                Get.offAllNamed('/dashboard');
                Get.snackbar('Vendor Profile Loaded', 'Vendor B: Shop Only (Stay, Rental, Trips, Experiences hidden)');
              } else if (val == 'demo_c') {
                auth.setDemoVendorCTripsExperiences();
                Get.offAllNamed('/dashboard');
                Get.snackbar('Vendor Profile Loaded', 'Vendor C: Tours & Trips + Local Experiences');
              } else if (val == 'demo_all') {
                auth.assignedServices.assignAll(ServiceType.values);
                auth.activeService.value = ServiceType.stay;
                Get.offAllNamed('/dashboard');
                Get.snackbar('Vendor Profile Loaded', 'Vendor D: All 5 Services Enabled');
              } else if (val == 'register') {
                Get.toNamed('/register');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('TEST SERVICE ISOLATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const PopupMenuItem(
                value: 'demo_a',
                child: Row(
                  children: [
                    Icon(Icons.hotel_rounded, size: 16, color: AppColors.stayService),
                    SizedBox(width: 4),
                    Icon(Icons.directions_car_rounded, size: 16, color: AppColors.rentalService),
                    SizedBox(width: 8),
                    Text('Vendor A: Stay + Vehicle Rental'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'demo_b',
                child: Row(
                  children: [
                    Icon(Icons.storefront_rounded, size: 16, color: AppColors.shopService),
                    SizedBox(width: 8),
                    Text('Vendor B: Shop Only'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'demo_c',
                child: Row(
                  children: [
                    Icon(Icons.hiking_rounded, size: 16, color: AppColors.tripsService),
                    SizedBox(width: 4),
                    Icon(Icons.local_activity_rounded, size: 16, color: AppColors.localExpService),
                    SizedBox(width: 8),
                    Text('Vendor C: Trips + Local Experiences'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'demo_all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive_rounded, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Vendor D: All 5 Services'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'register',
                child: Row(
                  children: [
                    Icon(Icons.person_add_outlined, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Register New Custom Vendor'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: AppDimensions.spaceSm),

          // Notifications bell
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none_rounded, size: 21),
            ),
            tooltip: 'Notifications',
            onPressed: () => Get.toNamed('/notifications'),
          ),

          // Theme toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
            ),
            tooltip: 'Toggle light / dark mode',
            onPressed: () {
              Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),

          const SizedBox(width: AppDimensions.spaceSm),

          // Profile Dropdown
          PopupMenuButton<String>(
            tooltip: 'Vendor profile',
            onSelected: (val) {
              if (val == 'profile') Get.toNamed('/profile');
              if (val == 'settings') Get.toNamed('/settings');
              if (val == 'logout') auth.logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(auth.vendorName.value, style: AppTextStyles.h4),
                    Text(auth.ownerName.value, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'profile', child: Text('Vendor Profile & KYC')),
              const PopupMenuItem(value: 'settings', child: Text('Account Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sign Out', style: TextStyle(color: AppColors.error)),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.primary,
                  child: Obx(() => Text(
                        auth.ownerName.value.isNotEmpty
                            ? auth.ownerName.value.substring(0, 1).toUpperCase()
                            : 'V',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
