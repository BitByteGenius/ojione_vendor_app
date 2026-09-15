import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/vendor_profile_controller.dart';

class EditProfileScreen extends GetView<VendorProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = controller.profile.value;
    final businessNameCtrl = TextEditingController(text: p?.businessName ?? '');
    final ownerNameCtrl = TextEditingController(text: p?.ownerName ?? '');
    final emailCtrl = TextEditingController(text: p?.email ?? '');
    final phoneCtrl = TextEditingController(text: p?.phone ?? '');
    final altPhoneCtrl = TextEditingController(text: p?.alternatePhone ?? '');

    return MainLayout(
      title: 'Edit Vendor Profile',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: AppCard(
            title: 'Basic Information',
            subtitle: 'Keep your primary business contact details up to date',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Business Name',
                  controller: businessNameCtrl,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                AppTextField(
                  label: 'Authorized Person Name',
                  controller: ownerNameCtrl,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                AppTextField(
                  label: 'Email Address',
                  controller: emailCtrl,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Primary Phone',
                        controller: phoneCtrl,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: AppTextField(
                        label: 'Alternate Phone',
                        controller: altPhoneCtrl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: 'Cancel',
                      type: AppButtonType.text,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    AppButton(
                      text: 'Save Changes',
                      onPressed: () {
                        controller.saveProfile({
                          'business_name': businessNameCtrl.text,
                          'owner_name': ownerNameCtrl.text,
                          'email': emailCtrl.text,
                          'phone': phoneCtrl.text,
                          'alternate_phone': altPhoneCtrl.text,
                        });
                        Get.back();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
