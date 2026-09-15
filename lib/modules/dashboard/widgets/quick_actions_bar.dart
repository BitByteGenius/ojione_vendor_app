import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/app_button.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return Obx(() {
      return Wrap(
        spacing: AppDimensions.spaceSm,
        runSpacing: AppDimensions.spaceSm,
        children: [
          if (auth.hasService(ServiceType.stay))
            AppButton(
              text: '+ Add Property',
              icon: Icons.hotel_rounded,
              type: AppButtonType.primary,
              height: AppDimensions.buttonHeightSm,
              onPressed: () => Get.toNamed('/stay/properties/add'),
            ),
          if (auth.hasService(ServiceType.trips))
            AppButton(
              text: '+ Add Trip Package',
              icon: Icons.hiking_rounded,
              type: AppButtonType.secondary,
              height: AppDimensions.buttonHeightSm,
              onPressed: () => Get.toNamed('/trips/packages/add'),
            ),
          if (auth.hasService(ServiceType.shop))
            AppButton(
              text: '+ Add Product',
              icon: Icons.add_business_rounded,
              type: AppButtonType.outline,
              height: AppDimensions.buttonHeightSm,
              onPressed: () => Get.toNamed('/shop/products/add'),
            ),
          if (auth.hasService(ServiceType.rental))
            AppButton(
              text: '+ Add Vehicle',
              icon: Icons.directions_car_rounded,
              type: AppButtonType.outline,
              height: AppDimensions.buttonHeightSm,
              onPressed: () => Get.toNamed('/rental/vehicles/add'),
            ),
          if (auth.hasService(ServiceType.localExperiences))
            AppButton(
              text: '+ Add Experience',
              icon: Icons.local_activity_rounded,
              type: AppButtonType.primary,
              height: AppDimensions.buttonHeightSm,
              onPressed: () => Get.toNamed('/experiences/add'),
            ),
        ],
      );
    });
  }
}
