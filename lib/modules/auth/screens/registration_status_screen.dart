import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../widgets/auth_layout.dart';

class RegistrationStatusScreen extends StatelessWidget {
  const RegistrationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return AuthLayout(
      title: 'Registration Status',
      subtitle: 'Your partner application has been recorded in the SewaSetu network.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Icon Badge
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success.withAlpha(80), width: 2),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: AppColors.success,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          Center(
            child: Text(
              'Application Submitted!',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Obx(() => Text(
                  'Hello, ${auth.ownerName.value}! Your vendor registration is provisioned. Your isolated service workspace is ready for setup.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Status details card
          AppCard(
            title: 'Application & Compliance Overview',
            subtitle: 'Real-time account activation status',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Vendor ID', auth.vendorId.value, isBold: true),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('KYC Verification', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 0.8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hourglass_top_rounded, size: 12, color: Color(0xFFB45309)),
                          SizedBox(width: 4),
                          Text(
                            'Documents In Review',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Portal Access', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF22C55E), width: 0.8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF15803D)),
                          SizedBox(width: 4),
                          Text(
                            'Active & Ready',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Selected Services
                const Text(
                  'Enabled Service Modules:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final services = auth.assignedServices.toList();
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: services.map((service) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: service.bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: service.color.withAlpha(120), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(service.icon, size: 15, color: service.color),
                            const SizedBox(width: 6),
                            Text(
                              service.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: service.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXl),

          // Primary CTA button to launch Vendor Home
          AppButton(
            text: 'Go to Vendor Home',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => Get.offAllNamed(AppRoutes.vendorShell),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
