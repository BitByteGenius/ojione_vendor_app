import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/rental_controller.dart';

class AddVehicleScreen extends GetView<RentalController> {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Add Vehicle to Rental Fleet',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AppCard(
            title: 'Vehicle Registration & Details',
            subtitle: 'Provide vehicle specifications and select the authorized operating city',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Manufacturer / Make',
                        hint: 'e.g. Toyota, Mahindra, Tata',
                        controller: controller.makeController,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: AppTextField(
                        label: 'Model Name',
                        hint: 'e.g. Innova Crysta, Thar',
                        controller: controller.modelController,
                        validator: Validators.required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Registration Number',
                        hint: 'e.g. AS-01-AB-1234',
                        controller: controller.regNumberController,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Operating City (Backend-Driven)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedCity.value,
                                decoration: const InputDecoration(),
                                items: controller.cities
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) => controller.selectedCity.value = v ?? 'Guwahati',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Daily Rental Rate (₹)',
                        hint: 'e.g. 3500',
                        controller: controller.pricePerDayController,
                        keyboardType: TextInputType.number,
                        validator: Validators.numeric,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rental Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedRentalType.value,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(value: 'Both', child: Text('Self-Drive & Chauffeur')),
                                  DropdownMenuItem(value: 'Self-Drive', child: Text('Self-Drive Only')),
                                  DropdownMenuItem(value: 'Chauffeur Driven', child: Text('With Chauffeur Only')),
                                ],
                                onChanged: (v) => controller.selectedRentalType.value = v ?? 'Both',
                              )),
                        ],
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
                      text: 'Add to Fleet',
                      onPressed: controller.submitVehicle,
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
