import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/local_experiences_controller.dart';

class AddExperienceScreen extends GetView<LocalExperiencesController> {
  const AddExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Host a Local Experience',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AppCard(
            title: 'Experience Details',
            subtitle: 'Share your city culture, culinary heritage, or artisan skills with travelers',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Experience Title',
                  hint: 'e.g. Traditional Assamese Silk Weaving & Spinning Class',
                  controller: controller.titleController,
                  validator: Validators.required,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                AppTextField(
                  label: 'Detailed Description & Story',
                  hint: 'Explain what guests will do, learn, taste, or make...',
                  controller: controller.descriptionController,
                  maxLines: 4,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedCategory.value,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Cultural Walk', child: Text('Cultural Walk')),
                                  DropdownMenuItem(value: 'Food & Tea Tasting', child: Text('Food & Tea Tasting')),
                                  DropdownMenuItem(value: 'Cooking Class', child: Text('Cooking Class')),
                                  DropdownMenuItem(value: 'Craft Workshop', child: Text('Craft Workshop')),
                                  DropdownMenuItem(value: 'Village Experience', child: Text('Village Experience')),
                                  DropdownMenuItem(value: 'Nature & Birding Walk', child: Text('Nature & Birding Walk')),
                                ],
                                onChanged: (v) => controller.selectedCategory.value = v ?? 'Cultural Walk',
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: AppTextField(
                        label: 'Operating City',
                        hint: 'e.g. Guwahati, Jorhat, Tezpur',
                        controller: controller.cityController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                AppTextField(
                  label: 'Meeting Point / Landmark',
                  hint: 'e.g. North Gate of Kamakhya Temple Complex',
                  controller: controller.meetingPointController,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Duration (Hours)',
                        controller: controller.durationHoursController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: AppTextField(
                        label: 'Max Group Capacity',
                        controller: controller.maxCapacityController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: AppTextField(
                        label: 'Price per Guest (₹)',
                        hint: 'e.g. 750',
                        controller: controller.priceController,
                        keyboardType: TextInputType.number,
                        validator: Validators.numeric,
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
                      text: 'Submit for Verification',
                      onPressed: controller.submitExperience,
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
