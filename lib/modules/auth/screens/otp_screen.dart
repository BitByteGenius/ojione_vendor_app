import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_layout.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Verify Mobile Number',
      subtitle: 'Please enter the 6-digit OTP sent to your registered mobile number.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Enter OTP',
            hint: '1 2 3 4 5 6',
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.security_rounded, size: 20),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Obx(() => AppButton(
                text: 'Verify & Enter Dashboard',
                isLoading: controller.isLoading.value,
                onPressed: controller.verifyOtp,
              )),
          const SizedBox(height: AppDimensions.spaceMd),
          Center(
            child: TextButton(
              onPressed: () {
                Get.snackbar('Sent', 'A new OTP has been dispatched to your mobile');
              },
              child: Text(
                'Resend OTP Code',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
