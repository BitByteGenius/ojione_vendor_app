import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../enums/service_type.dart';
import '../enums/user_role.dart';

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
          Text(title, style: AppTextStyles.h3),
          const Spacer(),

          // Service count badge
          Obx(() {
            final count = auth.assignedServices.length;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSm + 2,
                vertical: AppDimensions.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '$count / 5 Services Active',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(width: AppDimensions.spaceMd),

          // Role Switcher & Live Service Demo Menu
          PopupMenuButton<String>(
            tooltip: 'Simulate Role / Service Access',
            icon: const Icon(Icons.tune_rounded, size: 20),
            onSelected: (val) {
              if (val.startsWith('role:')) {
                final roleStr = val.substring(5);
                auth.setRole(UserRole.fromString(roleStr));
              } else if (val.startsWith('toggle:')) {
                final srvStr = val.substring(7);
                auth.toggleService(ServiceType.fromString(srvStr));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('SIMULATE USER ROLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              ...UserRole.values.map(
                (r) => PopupMenuItem(
                  value: 'role:${r.name}',
                  child: Row(
                    children: [
                      Icon(
                        auth.currentRole.value == r ? Icons.radio_button_checked : Icons.radio_button_off,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(r.label),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text('TOGGLE ASSIGNED SERVICES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              ...ServiceType.values.map(
                (s) => PopupMenuItem(
                  value: 'toggle:${s.id}',
                  child: Row(
                    children: [
                      Icon(
                        auth.hasService(s) ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 16,
                        color: s.color,
                      ),
                      const SizedBox(width: 8),
                      Text(s.displayName),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Notifications bell
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none_rounded, size: 22),
            ),
            tooltip: 'Notifications',
            onPressed: () => Get.toNamed('/notifications'),
          ),

          const SizedBox(width: AppDimensions.spaceSm),

          // Theme toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
            ),
            tooltip: 'Toggle theme',
            onPressed: () {
              Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),

          const SizedBox(width: AppDimensions.spaceMd),

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
              const PopupMenuItem(value: 'profile', child: Text('Vendor Profile')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout', style: TextStyle(color: AppColors.error)),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    auth.ownerName.value.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceSm),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
