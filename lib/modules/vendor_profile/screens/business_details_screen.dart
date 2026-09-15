import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/vendor_profile_controller.dart';

class BusinessDetailsScreen extends GetView<VendorProfileController> {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Business & Payout Details',
      body: Obx(() {
        final p = controller.profile.value;
        if (p == null) return const AppLoader();

        final b = p.business;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                title: 'Legal & Tax Details',
                subtitle: 'Statutory registration and tax identifiers',
                child: Column(
                  children: [
                    _detailRow('Business Type', b.businessType),
                    _detailRow('Registration / Incorporation Number', b.registrationNumber),
                    _detailRow('GSTIN Number', b.gstin),
                    _detailRow('Permanent Account Number (PAN)', b.panNumber),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              AppCard(
                title: 'Registered Business Address',
                subtitle: 'Official operating location for service verification',
                child: Column(
                  children: [
                    _detailRow('Address Line', b.registeredAddress),
                    _detailRow('City', b.city),
                    _detailRow('State', b.state),
                    _detailRow('Postal Pincode', b.pincode),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              AppCard(
                title: 'Bank Account / Payout Settlement',
                subtitle: 'Designated account for verified marketplace disbursements',
                child: Column(
                  children: [
                    _detailRow('Bank Name', b.bankName),
                    _detailRow('Account Holder Name', b.accountHolderName),
                    _detailRow('Account Number', b.accountNumber),
                    _detailRow('IFSC Code', b.ifscCode),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextSecondary)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
