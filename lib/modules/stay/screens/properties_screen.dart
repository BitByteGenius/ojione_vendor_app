import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../widgets/property_card.dart';

class PropertiesScreen extends GetView<StayController> {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Properties & Accommodations',
      trailingHeader: AppButton(
        text: '+ Add Property',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/stay/properties/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return const AppLoader(message: 'Loading properties...');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          itemCount: controller.properties.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spaceMd),
          itemBuilder: (context, index) {
            final prop = controller.properties[index];
            return PropertyCard(property: prop);
          },
        );
      }),
    );
  }
}
