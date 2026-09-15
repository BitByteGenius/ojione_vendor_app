import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                title: 'Notification Preferences',
                subtitle: 'Manage how customer bookings and alerts are delivered',
                child: Column(
                  children: [
                    Obx(() => SwitchListTile(
                          title: const Text('Email Notifications'),
                          subtitle: const Text('Receive booking confirmations and payout receipts via email'),
                          value: controller.emailNotifications.value,
                          onChanged: (val) => controller.emailNotifications.value = val,
                          activeThumbColor: AppColors.primary,
                        )),
                    Obx(() => SwitchListTile(
                          title: const Text('SMS Notifications'),
                          subtitle: const Text('Instant SMS for urgent booking arrival notices'),
                          value: controller.smsNotifications.value,
                          onChanged: (val) => controller.smsNotifications.value = val,
                          activeThumbColor: AppColors.primary,
                        )),
                    Obx(() => SwitchListTile(
                          title: const Text('WhatsApp Notifications'),
                          subtitle: const Text('Direct messaging for fast guest communications'),
                          value: controller.whatsappAlerts.value,
                          onChanged: (val) => controller.whatsappAlerts.value = val,
                          activeThumbColor: AppColors.primary,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              AppCard(
                title: 'Marketplace Operations',
                subtitle: 'Automatic confirmation and reservation rules',
                child: Column(
                  children: [
                    Obx(() => SwitchListTile(
                          title: const Text('Instant Booking Acceptance'),
                          subtitle: const Text('Automatically confirm bookings when dates/capacity are open'),
                          value: controller.instantBooking.value,
                          onChanged: (val) => controller.instantBooking.value = val,
                          activeThumbColor: AppColors.primary,
                        )),
                    ListTile(
                      title: const Text('Preferred Language'),
                      subtitle: const Text('Dashboard and reports display language'),
                      trailing: Obx(() => DropdownButton<String>(
                            value: controller.language.value,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 'English', child: Text('English')),
                              DropdownMenuItem(value: 'Assamese', child: Text('Assamese (অসমীয়া)')),
                              DropdownMenuItem(value: 'Hindi', child: Text('Hindi (हिंदी)')),
                              DropdownMenuItem(value: 'Bengali', child: Text('Bengali (বাংলা)')),
                            ],
                            onChanged: (val) => controller.language.value = val ?? 'English',
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
