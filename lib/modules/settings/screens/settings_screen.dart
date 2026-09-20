import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Vendor Settings',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              title: 'Notification Preferences',
              subtitle: 'Manage how customer bookings and alerts are delivered',
              child: Column(
                children: [
                  Obx(() => _buildSwitchRow(
                        title: 'Email Notifications',
                        subtitle: 'Receive booking confirmations and payout receipts via email',
                        value: controller.emailNotifications.value,
                        onChanged: (val) => controller.emailNotifications.value = val,
                      )),
                  const Divider(height: 20),
                  Obx(() => _buildSwitchRow(
                        title: 'SMS Notifications',
                        subtitle: 'Instant SMS for urgent booking arrival notices',
                        value: controller.smsNotifications.value,
                        onChanged: (val) => controller.smsNotifications.value = val,
                      )),
                  const Divider(height: 20),
                  Obx(() => _buildSwitchRow(
                        title: 'WhatsApp Notifications',
                        subtitle: 'Direct messaging for fast guest communications',
                        value: controller.whatsappAlerts.value,
                        onChanged: (val) => controller.whatsappAlerts.value = val,
                      )),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            AppCard(
              title: 'Marketplace Operations',
              subtitle: 'Automatic confirmation and reservation rules',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => _buildSwitchRow(
                        title: 'Instant Booking Acceptance',
                        subtitle: 'Automatically confirm bookings when dates/capacity are open',
                        value: controller.instantBooking.value,
                        onChanged: (val) => controller.instantBooking.value = val,
                      )),
                  const Divider(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preferred Language', style: AppTextStyles.h4),
                      const SizedBox(height: 2),
                      Text('Dashboard and reports display language', style: AppTextStyles.caption),
                      const SizedBox(height: 10),
                      Obx(() => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                              border: Border.all(color: Colors.grey.withAlpha(80)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.language.value,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: 'English', child: Text('English')),
                                  DropdownMenuItem(value: 'Assamese', child: Text('Assamese (অসমীয়া)')),
                                  DropdownMenuItem(value: 'Hindi', child: Text('Hindi (हिंदी)')),
                                  DropdownMenuItem(value: 'Bengali', child: Text('Bengali (বাংলা)')),
                                ],
                                onChanged: (val) => controller.language.value = val ?? 'English',
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h4),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
