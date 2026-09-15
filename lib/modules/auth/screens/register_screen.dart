import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_layout.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Become a SewaSetu Vendor',
      subtitle: 'Register your business and choose which services you want to offer.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Business / Trade Name',
            hint: 'e.g. Kaziranga Eco Resort',
            controller: controller.businessNameController,
            validator: Validators.required,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          AppTextField(
            label: 'Authorized Person Name',
            hint: 'e.g. Gunajit Sharma',
            controller: controller.ownerNameController,
            validator: Validators.required,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Email Address',
                  hint: 'vendor@example.com',
                  controller: controller.emailController,
                  validator: Validators.email,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: AppTextField(
                  label: 'Mobile Number',
                  hint: '9876543210',
                  controller: controller.phoneController,
                  validator: Validators.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text(
            'Select Services You Offer',
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'You can manage multiple services under a single vendor dashboard.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppDimensions.spaceSm),

          // 5 Service Selection Chips
          Obx(() {
            return Wrap(
              spacing: AppDimensions.spaceSm,
              runSpacing: AppDimensions.spaceSm,
              children: ServiceType.values.map((service) {
                final isSelected = controller.selectedServices.contains(service);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(service.icon, size: 16, color: isSelected ? Colors.white : service.color),
                      const SizedBox(width: 6),
                      Text(service.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => controller.toggleServiceSelection(service),
                  selectedColor: service.color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: AppDimensions.spaceXl),
          Obx(() => AppButton(
                text: 'Create Vendor Account',
                isLoading: controller.isLoading.value,
                onPressed: controller.register,
              )),
          const SizedBox(height: AppDimensions.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already registered? ', style: AppTextStyles.bodySmall),
              InkWell(
                onTap: () => Get.toNamed('/login'),
                child: Text(
                  'Sign In',
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
