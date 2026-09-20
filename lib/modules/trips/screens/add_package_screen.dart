import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/trips_controller.dart';

class AddPackageScreen extends GetView<TripsController> {
  const AddPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Create Tour Package',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: AppCard(
          title: 'Trip Details',
          subtitle: 'Define package title, duration, pricing, and covered destinations',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Package Title',
                hint: 'e.g. Majuli Cultural & Mask-Making Heritage Trail',
                controller: controller.titleController,
                validator: Validators.required,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Overview & Highlights',
                hint: 'Describe key sightseeing spots, cultural experiences...',
                controller: controller.descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Duration (Days)',
                controller: controller.daysController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Duration (Nights)',
                controller: controller.nightsController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Price per Person (₹)',
                hint: 'e.g. 12500',
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Key Destinations (comma separated)',
                hint: 'e.g. Kaziranga, Majuli, Jorhat',
                controller: controller.destinationsController,
              ),
              const SizedBox(height: AppDimensions.spaceXl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      type: AppButtonType.text,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: 'Create Package',
                      onPressed: controller.submitPackage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
