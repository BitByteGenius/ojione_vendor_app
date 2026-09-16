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
      title: 'Join SewaSetu Partner Network',
      subtitle: 'Register your business and choose the marketplace service(s) you wish to operate.',
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stepper Progress Header
            _buildStepIndicator(context),
            const SizedBox(height: AppDimensions.spaceLg),

            // Step Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildCurrentStep(context),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Navigation Buttons (Back / Next / Submit)
            _buildNavigationButtons(),

            const SizedBox(height: AppDimensions.spaceMd),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already registered? ', style: AppTextStyles.bodySmall),
                InkWell(
                  onTap: () => Get.toNamed('/login'),
                  child: Text(
                    'Sign In to Dashboard',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final step = controller.currentStep.value;
    final steps = ['Personal', 'Address', 'Services', 'Review'];

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = step > index;
        final isCurrent = step == index;
        final color = isCompleted || isCurrent ? AppColors.primary : Colors.grey[300]!;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.primary
                                : (isCurrent ? AppColors.primaryLight : Colors.grey[200]),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted || isCurrent
                                  ? AppColors.primary
                                  : Colors.grey[400]!,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrent
                                          ? AppColors.primary
                                          : Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            steps[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: isCurrent
                                  ? AppColors.primary
                                  : (isCompleted ? Colors.black87 : Colors.grey[500]),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1) const SizedBox(width: 8),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildStep1Personal();
      case 1:
        return _buildStep2Address();
      case 2:
        return _buildStep3Services();
      case 3:
      default:
        return _buildStep4Review();
    }
  }

  Widget _buildStep1Personal() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Personal & Business Identity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter authorized owner name, business details, and official contact information.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        AppTextField(
          label: 'Full Name (As on Aadhaar)',
          hint: 'e.g. Gunajit Sharma',
          controller: controller.fullNameController,
          validator: Validators.required,
          prefixIcon: const Icon(Icons.person_outline_rounded, size: 18),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        AppTextField(
          label: 'Business / Trade Name',
          hint: 'e.g. Kaziranga Eco-Lodge & Car Rentals',
          controller: controller.businessNameController,
          validator: Validators.required,
          prefixIcon: const Icon(Icons.business_outlined, size: 18),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        AppTextField(
          label: 'Aadhaar Number (12 Digits)',
          hint: 'e.g. 7890 1234 5678',
          controller: controller.aadhaarController,
          validator: (val) {
            if (val == null || val.replaceAll(' ', '').length < 12) {
              return 'Enter a valid 12-digit Aadhaar number';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.badge_outlined, size: 18),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Phone Number',
                hint: '9876543210',
                controller: controller.phoneController,
                validator: Validators.phone,
                prefixIcon: const Icon(Icons.phone_outlined, size: 18),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: AppTextField(
                label: 'Gmail / Email Address',
                hint: 'vendor@gmail.com',
                controller: controller.emailController,
                validator: Validators.email,
                prefixIcon: const Icon(Icons.mail_outline_rounded, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2Address() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2: Business Address & Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Your registered commercial address for location verification and billing.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'City / District',
                hint: 'e.g. Guwahati',
                controller: controller.cityController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.location_city_outlined, size: 18),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: AppTextField(
                label: 'State',
                hint: 'e.g. Assam',
                controller: controller.stateController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.map_outlined, size: 18),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: AppTextField(
                label: 'Pincode',
                hint: 'e.g. 781001',
                controller: controller.pincodeController,
                validator: Validators.required,
                prefixIcon: const Icon(Icons.pin_drop_outlined, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        AppTextField(
          label: 'Full Address',
          hint: 'Plot / Building / Street / Landmark',
          controller: controller.addressController,
          validator: Validators.required,
          maxLines: 3,
          prefixIcon: const Icon(Icons.home_outlined, size: 18),
        ),
      ],
    );
  }

  Widget _buildStep3Services() {
    return Column(
      key: const ValueKey('step3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 3: Select Marketplace Service(s)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Select ONE or MULTIPLE services you offer. You will only see the dashboard for your selected service(s).',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppDimensions.spaceMd),

        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceSm + 2),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFF1D4ED8), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Service Isolation: Selecting Stay + Rental gives you dedicated Stay and Rental portals, while completely hiding Shop, Trips, and Local Experiences.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),

        // 5 Dedicated Service Cards
        ...ServiceType.values.map((service) {
          final isSelected = controller.selectedServices.contains(service);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
            child: InkWell(
              onTap: () => controller.toggleServiceSelection(service),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: isSelected ? service.bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: isSelected ? service.color : AppColors.lightBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? service.color
                            : service.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Icon(
                        service.icon,
                        color: isSelected ? Colors.white : service.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.displayName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? service.color : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.black87
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      activeColor: service.color,
                      onChanged: (_) => controller.toggleServiceSelection(service),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep4Review() {
    return Column(
      key: const ValueKey('step4'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 4: Review Details & Confirm',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Please verify your registration information before finalizing account submission.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppDimensions.spaceMd),

        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reviewRow('Full Name', controller.fullNameController.text),
              _reviewRow('Business Name', controller.businessNameController.text),
              _reviewRow('Aadhaar Number', controller.aadhaarController.text),
              _reviewRow('Phone', controller.phoneController.text),
              _reviewRow('Email', controller.emailController.text),
              const Divider(height: 20),
              _reviewRow('Address', '${controller.addressController.text}, ${controller.cityController.text}, ${controller.stateController.text} - ${controller.pincodeController.text}'),
              const Divider(height: 20),
              const Text(
                'Assigned Services (Strict Separation):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.selectedServices.map((s) {
                  return Chip(
                    avatar: Icon(s.icon, size: 16, color: s.color),
                    label: Text(s.displayName, style: TextStyle(color: s.color, fontWeight: FontWeight.bold, fontSize: 12)),
                    backgroundColor: s.bgColor,
                    side: BorderSide(color: s.color.withAlpha(80)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: controller.termsAccepted.value,
              activeColor: AppColors.primary,
              onChanged: (val) => controller.termsAccepted.value = val ?? false,
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'I declare that the information provided above is accurate and I agree to the SewaSetu Partner Agreement and Verification Policy.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final step = controller.currentStep.value;

    return Row(
      children: [
        if (step > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: controller.previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
        ],
        Expanded(
          flex: 2,
          child: AppButton(
            text: step == 3 ? 'Submit Vendor Registration' : 'Continue to ${['Address', 'Services', 'Review'][step]}',
            isLoading: controller.isLoading.value,
            icon: step == 3 ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
            onPressed: step == 3 ? controller.submitRegistration : controller.nextStep,
          ),
        ),
      ],
    );
  }
}
