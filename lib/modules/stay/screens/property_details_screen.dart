import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../models/property_model.dart';
import '../widgets/property_status_chip.dart';
import '../widgets/room_card.dart';

class PropertyDetailsScreen extends GetView<StayController> {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyModel prop = Get.arguments as PropertyModel? ?? controller.selectedProperty.value ?? controller.properties.first;

    return MainLayout(
      title: prop.name,
      trailingHeader: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PropertyStatusChip(status: prop.status),
          const SizedBox(width: AppDimensions.spaceSm),
          AppButton(
            text: 'Edit',
            icon: Icons.edit_outlined,
            height: AppDimensions.buttonHeightSm,
            type: AppButtonType.outline,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              title: 'Overview',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prop.description, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.lightTextMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${prop.address}, ${prop.city}, ${prop.state} - ${prop.pincode}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 16, color: AppColors.lightTextMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Check-in: ${prop.checkInTime} • Check-out: ${prop.checkOutTime}',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            AppCard(
              title: 'Rooms & Inventories (${prop.rooms.length})',
              trailing: AppButton(
                text: '+ Add Room',
                height: AppDimensions.buttonHeightSm,
                onPressed: () {},
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prop.rooms.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppDimensions.spaceSm),
                itemBuilder: (context, index) {
                  return RoomCard(room: prop.rooms[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
