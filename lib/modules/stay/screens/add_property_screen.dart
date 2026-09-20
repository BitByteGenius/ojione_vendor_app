import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';

class AddPropertyScreen extends GetView<StayController> {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Add New Property',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: AppCard(
          title: 'Property Overview',
          subtitle: 'Provide accurate information about your accommodation listing',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Property Name',
                hint: 'e.g. Kaziranga Eco-Resort & Spa',
                controller: controller.nameController,
                validator: Validators.required,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Description',
                hint: 'Describe your property, surroundings, and experience offered...',
                controller: controller.descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Property Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Obx(() => DropdownButtonFormField<String>(
                        initialValue: controller.selectedPropertyType.value,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'Resort', child: Text('Resort')),
                          DropdownMenuItem(value: 'Homestay', child: Text('Homestay')),
                          DropdownMenuItem(value: 'Hotel', child: Text('Hotel')),
                          DropdownMenuItem(value: 'Villa', child: Text('Villa')),
                          DropdownMenuItem(value: 'Eco Cottage', child: Text('Eco Cottage')),
                        ],
                        onChanged: (v) => controller.selectedPropertyType.value = v ?? 'Resort',
                      )),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Base Price per Night (₹)',
                hint: 'e.g. 3500',
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Full Address',
                hint: 'Street, landmark, or location',
                controller: controller.addressController,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'City / Destination',
                hint: 'e.g. Kaziranga',
                controller: controller.cityController,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'State',
                hint: 'e.g. Assam',
                controller: controller.stateController,
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
                      text: 'Submit for Approval',
                      onPressed: controller.submitProperty,
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
