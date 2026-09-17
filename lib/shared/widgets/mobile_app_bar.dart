import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/enums/vendor_status.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showVendorBadge;
  final bool showNotificationBell;
  final Color? backgroundColor;

  const MobileAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.showVendorBadge = false,
    this.showNotificationBell = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 68.0 : 56.0);

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBackButton || (Navigator.canPop(context));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkSurface : Colors.white);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                if (canGoBack)
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        onTap: onBackPressed ?? () => Get.back(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.h3.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (showVendorBadge) ...[
                            const SizedBox(width: 8),
                            _buildVerificationBadge(),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (actions != null) ...actions!,

                if (showNotificationBell) ...[
                  const SizedBox(width: 4),
                  _buildNotificationButton(isDark),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Obx(() {
      final status = AuthService.to.verificationStatus.value;
      final isVerified = status == VendorVerificationStatus.verified;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: isVerified ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isVerified ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVerified ? Icons.verified_rounded : Icons.pending_outlined,
              size: 12,
              color: isVerified ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(width: 3),
            Text(
              isVerified ? 'Verified' : 'In Review',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isVerified ? AppColors.success : AppColors.warning,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNotificationButton(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: () => Get.toNamed('/notifications'),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 20,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
