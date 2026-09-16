import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../shared/enums/service_type.dart';

class ServiceGuardMiddleware extends GetMiddleware {
  final ServiceType requiredService;

  ServiceGuardMiddleware(this.requiredService);

  @override
  RouteSettings? redirect(String? route) {
    // Check if AuthService is registered and user has this service assigned
    if (Get.isRegistered<AuthService>()) {
      final auth = AuthService.to;
      if (!auth.hasService(requiredService)) {
        // Vendor not authorized for this service
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Service Access Restricted',
            'You are not registered for "${requiredService.displayName}". Access is limited to your assigned services.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFEF2F2),
            colorText: const Color(0xFF991B1B),
            icon: const Icon(Icons.lock_outline_rounded, color: Color(0xFFDC2626)),
            duration: const Duration(seconds: 4),
          );
        });
        return const RouteSettings(name: '/dashboard');
      }
    }
    return null;
  }
}
