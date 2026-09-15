import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/vendor_profile_controller.dart';

class ProfileScreen extends GetView<VendorProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Vendor Profile',
      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const AppLoader(message: 'Loading vendor profile...');
        }

        final p = controller.profile.value;
        if (p == null) {
          return const Center(child: Text('Profile not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Summary Header Card
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        p.businessName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(p.businessName, style: AppTextStyles.h2),
                              const SizedBox(width: AppDimensions.spaceSm),
                              AppStatusChip(status: p.verificationStatus),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spaceXs),
                          Text('Authorized Person: ${p.ownerName} • ID: ${p.id}', style: AppTextStyles.subtitle),
                          const SizedBox(height: AppDimensions.spaceSm),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text('${p.rating} (${p.totalReviews} reviews)', style: AppTextStyles.bodySmall),
                              const SizedBox(width: AppDimensions.spaceMd),
                              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.lightTextMuted),
                              const SizedBox(width: 4),
                              Text('${p.business.city}, ${p.business.state}', style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: 'Edit Profile',
                      icon: Icons.edit_outlined,
                      type: AppButtonType.outline,
                      onPressed: () => Get.toNamed('/profile/edit'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Navigation tabs / quick sub-screens
              Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.business_rounded, size: 16),
                    label: const Text('Business Details'),
                    onPressed: () => Get.toNamed('/profile/business'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.description_outlined, size: 16),
                    label: const Text('Documents & KYC'),
                    onPressed: () => Get.toNamed('/profile/documents'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Contact & Business Information
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppCard(
                          title: 'Contact Information',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow('Email', p.email, Icons.email_outlined),
                              _infoRow('Primary Phone', p.phone, Icons.phone_outlined),
                              _infoRow('Alternate Phone', p.alternatePhone, Icons.phone_android_outlined),
                            ],
                          ),
                        ),
                      ),
                      if (isWide) const SizedBox(width: AppDimensions.spaceLg),
                      if (isWide)
                        Expanded(
                          child: AppCard(
                            title: 'Active Marketplace Services',
                            child: Wrap(
                              spacing: AppDimensions.spaceSm,
                              runSpacing: AppDimensions.spaceSm,
                              children: p.assignedServices.map((s) {
                                return Chip(
                                  avatar: Icon(s.icon, size: 16, color: s.color),
                                  label: Text(s.displayName),
                                  backgroundColor: s.bgColor,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.lightTextMuted),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
