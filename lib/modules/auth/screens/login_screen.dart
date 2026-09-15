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

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Welcome Back',
      subtitle: 'Log in to manage your marketplace services and bookings.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Email or Mobile Number',
            hint: 'e.g. vendor@sewasetu.com',
            controller: controller.emailController,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: Validators.required,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Obx(() => AppTextField(
                label: 'Password',
                hint: '••••••••',
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
          const SizedBox(height: AppDimensions.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (val) => controller.rememberMe.value = val ?? false,
                        activeColor: AppColors.primary,
                      ),
                      Text('Remember me', style: AppTextStyles.bodySmall),
                    ],
                  )),
              TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Obx(() => AppButton(
                text: 'Sign In to Vendor Panel',
                isLoading: controller.isLoading.value,
                onPressed: controller.login,
              )),
          const SizedBox(height: AppDimensions.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have a vendor account? ", style: AppTextStyles.bodySmall),
              InkWell(
                onTap: () => Get.toNamed('/register'),
                child: Text(
                  'Register here',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
