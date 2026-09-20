import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/shop_controller.dart';

class AddProductScreen extends GetView<ShopController> {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Add Marketplace Product',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: AppCard(
          title: 'Product Information',
          subtitle: 'Provide product details, state of origin, and inventory levels',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Product Title',
                hint: 'e.g. Traditional Brass Sarthebari Kahi Bowl',
                controller: controller.nameController,
                validator: Validators.required,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Description & Craft Details',
                hint: 'Describe materials, heritage origin, and artisan technique...',
                controller: controller.descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Origin State',
                hint: 'e.g. Assam, Bihar, Meghalaya...',
                controller: controller.stateController,
                validator: Validators.required,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Category',
                hint: 'e.g. Handloom, Metalcraft, Food',
                controller: controller.categoryController,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Retail Price (₹)',
                hint: 'e.g. 2400',
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppTextField(
                label: 'Initial Stock Quantity',
                hint: 'e.g. 25',
                controller: controller.stockController,
                keyboardType: TextInputType.number,
                validator: Validators.numeric,
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
                      text: 'Save Product',
                      onPressed: controller.submitProduct,
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
