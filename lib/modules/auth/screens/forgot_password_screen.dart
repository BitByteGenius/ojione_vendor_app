import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_layout.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Reset Password',
      subtitle: 'Enter your registered email address to receive reset instructions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Registered Email',
            hint: 'vendor@example.com',
            controller: controller.emailController,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: Validators.email,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Obx(() => AppButton(
                text: 'Send Reset Link',
                isLoading: controller.isLoading.value,
                onPressed: controller.forgotPassword,
              )),
          const SizedBox(height: AppDimensions.spaceMd),
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Back to Sign In',
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
