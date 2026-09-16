import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../widgets/auth_layout.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return AuthLayout(
      title: 'Registration Submitted',
      subtitle: 'Your multi-service vendor account has been provisioned.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success Icon Badge
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          Center(
            child: Text(
              'Account Created Successfully!',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Welcome, ${auth.ownerName.value}! Your vendor application is active and your tailored business environment is ready.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Verification & Service Isolation Status Card
          AppCard(
            title: 'Account & Service Configuration',
            subtitle: 'Strict service separation is active for your account',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Vendor ID:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Obx(() => Text(auth.vendorId.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('KYC Verification:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hourglass_top_rounded, size: 12, color: AppColors.warning),
                          SizedBox(width: 4),
                          Text(
                            'Pending Review',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                const Text(
                  'Enabled Service Portals:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your sidebar and workspace will strictly show only the following services you selected during registration:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: auth.assignedServices.map((s) {
                      return Chip(
                        avatar: Icon(s.icon, size: 16, color: s.color),
                        label: Text(
                          s.displayName,
                          style: TextStyle(
                            color: s.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: s.bgColor,
                        side: BorderSide(color: s.color.withAlpha(90)),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spaceLg),

          // Direct action button
          AppButton(
            text: 'Launch Vendor Panel',
            icon: Icons.dashboard_rounded,
            onPressed: () => Get.offAllNamed('/dashboard'),
          ),
        ],
      ),
    );
  }
}
