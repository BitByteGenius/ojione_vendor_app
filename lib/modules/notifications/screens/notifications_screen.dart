import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/notifications_controller.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Notifications & Alerts',
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const AppLoader(message: 'Loading notifications...');
        }

        if (controller.notifications.isEmpty) {
          return const AppEmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No Notifications',
            message: 'You are completely caught up!',
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'System & Service Alerts',
            subtitle: 'Real-time updates regarding bookings, approvals, and payouts',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.notifications.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final n = controller.notifications[index];
                return InkWell(
                  onTap: () {
                    controller.markAsRead(n.id);
                    if (n.actionRoute != null) {
                      Get.toNamed(n.actionRoute!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: _typeColor(n.type).withAlpha(25),
                          child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n.title,
                                      style: AppTextStyles.h4,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!n.isRead) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                n.message,
                                style: AppTextStyles.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(Formatters.dateTime(n.createdAt), style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return AppColors.stayService;
      case NotificationType.approval:
        return AppColors.success;
      case NotificationType.payment:
        return AppColors.primary;
      case NotificationType.vendor:
        return AppColors.secondary;
      case NotificationType.system:
        return AppColors.info;
    }
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_month_rounded;
      case NotificationType.approval:
        return Icons.verified_rounded;
      case NotificationType.payment:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.vendor:
        return Icons.person_outline_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }
}
