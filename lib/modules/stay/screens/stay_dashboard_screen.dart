import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../widgets/property_card.dart';

class StayDashboardScreen extends GetView<StayController> {
  const StayDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Stay & Accommodation',
      trailingHeader: AppButton(
        text: '+ Add Property',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/stay/properties/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return const AppLoader(message: 'Loading properties & stays...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sub-navigation bar for Stay service
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.list_alt_rounded, size: 16),
                      label: const Text('All Properties'),
                      onPressed: () => Get.toNamed('/stay/properties'),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    ActionChip(
                      avatar: const Icon(Icons.bed_outlined, size: 16),
                      label: const Text('Rooms & Units'),
                      onPressed: () => Get.toNamed('/stay/rooms'),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    ActionChip(
                      avatar: const Icon(Icons.calendar_today_outlined, size: 16),
                      label: const Text('Availability & Calendar'),
                      onPressed: () => Get.toNamed('/stay/availability'),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    ActionChip(
                      avatar: const Icon(Icons.sell_outlined, size: 16),
                      label: const Text('Pricing & Discounts'),
                      onPressed: () => Get.toNamed('/stay/pricing'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Total Properties',
                      '${controller.properties.length}',
                      Icons.apartment_rounded,
                      AppColors.stayService,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _statCard(
                      'Live Rooms / Units',
                      '10',
                      Icons.bed_rounded,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _statCard(
                      'Avg. Occupancy',
                      '78%',
                      Icons.pie_chart_outline_rounded,
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Properties List
              AppCard(
                title: 'Active Listed Properties',
                subtitle: 'Manage room inventory, pricing rules, photos and bookings',
                trailing: TextButton(
                  onPressed: () => Get.toNamed('/stay/properties'),
                  child: const Text('View All'),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.properties.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spaceMd),
                  itemBuilder: (context, index) {
                    final prop = controller.properties[index];
                    return PropertyCard(property: prop);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(30),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.h3.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
