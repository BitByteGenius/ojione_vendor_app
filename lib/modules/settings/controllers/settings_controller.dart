import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final emailNotifications = true.obs;
  final smsNotifications = true.obs;
  final whatsappAlerts = true.obs;
  final instantBooking = true.obs;
  final language = 'English'.obs;
  final isDarkMode = false.obs;

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
