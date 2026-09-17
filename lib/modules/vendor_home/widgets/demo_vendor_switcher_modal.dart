import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/enums/service_type.dart';

class DemoVendorSwitcherModal extends StatelessWidget {
  const DemoVendorSwitcherModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DemoVendorSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceLg,
        AppDimensions.spaceSm,
        AppDimensions.spaceLg,
        AppDimensions.space2xl,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Switch Vendor Profile', style: AppTextStyles.h3),
                    const Text(
                      'Test strict multi-service access control & isolation',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // Profile Options
            _buildVendorOption(
              title: 'Vendor A: Stay + Vehicle Rental',
              subtitle: 'Gunajit Sharma • Assam Heritage & Car Rentals',
              services: [ServiceType.stay, ServiceType.rental],
              isSelected: auth.assignedServices.length == 2 &&
                  auth.assignedServices.contains(ServiceType.stay) &&
                  auth.assignedServices.contains(ServiceType.rental),
              onTap: () {
                auth.setDemoVendorAStayRental();
                Get.back();
                Get.snackbar('Profile Switched', 'Active: Stay + Vehicle Rental',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            _buildVendorOption(
              title: 'Vendor B: Shop Only (Indigenous Crafts)',
              subtitle: 'Ananya Goswami • Pragjyotish Silk Store',
              services: [ServiceType.shop],
              isSelected: auth.assignedServices.length == 1 &&
                  auth.assignedServices.contains(ServiceType.shop),
              onTap: () {
                auth.setDemoVendorBShopOnly();
                Get.back();
                Get.snackbar('Profile Switched', 'Active: Shop Only (Stay/Trips Hidden)',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            _buildVendorOption(
              title: 'Vendor C: Tours & Trips + Local Experiences',
              subtitle: 'Bikramjit Saikia • Brahmaputra Expeditions',
              services: [ServiceType.trips, ServiceType.localExperiences],
              isSelected: auth.assignedServices.length == 2 &&
                  auth.assignedServices.contains(ServiceType.trips) &&
                  auth.assignedServices.contains(ServiceType.localExperiences),
              onTap: () {
                auth.setDemoVendorCTripsExperiences();
                Get.back();
                Get.snackbar('Profile Switched', 'Active: Tours & Trips + Local Experiences',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            _buildVendorOption(
              title: 'Vendor D: Stay + Shop + Local Experiences',
              subtitle: 'Priyanka Borah • Kaziranga Cultural Eco-Resort',
              services: [ServiceType.stay, ServiceType.shop, ServiceType.localExperiences],
              isSelected: auth.assignedServices.length == 3 &&
                  auth.assignedServices.contains(ServiceType.stay) &&
                  auth.assignedServices.contains(ServiceType.shop) &&
                  auth.assignedServices.contains(ServiceType.localExperiences),
              onTap: () {
                auth.vendorId.value = 'VEN-DEMO-D';
                auth.vendorName.value = 'Kaziranga Cultural Eco-Resort & Craft Village';
                auth.ownerName.value = 'Priyanka Borah';
                auth.email.value = 'priyanka@kazirangaecoresort.com';
                auth.phone.value = '+91 94351 99887';
                auth.aadhaarNumber.value = '8899 4433 2211';
                auth.city.value = 'Kaziranga';
                auth.state.value = 'Assam';
                auth.pincode.value = '785609';
                auth.address.value = 'Central Range, Kohora, Kaziranga';
                auth.assignedServices.assignAll([
                  ServiceType.stay,
                  ServiceType.shop,
                  ServiceType.localExperiences,
                ]);
                auth.activeService.value = ServiceType.stay;
                Get.back();
                Get.snackbar('Profile Switched', 'Active: Stay + Shop + Local Experiences',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorOption({
    required String title,
    required String subtitle,
    required List<ServiceType> services,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withAlpha(15) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: services.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: s.bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: s.color.withAlpha(90), width: 0.8),
                          ),
                          child: Text(
                            s.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: s.color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
