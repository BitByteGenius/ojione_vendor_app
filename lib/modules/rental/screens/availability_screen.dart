import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/rental_controller.dart';

class RentalAvailabilityScreen extends GetView<RentalController> {
  const RentalAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Vehicle Fleet Availability',
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Fleet Status',
            subtitle: 'Real-time booking and dispatch status across operating cities',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.vehicles.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final v = controller.vehicles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.directions_car_rounded, color: Colors.blueAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.displayName,
                              style: AppTextStyles.h4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'City: ${v.operatingCity} • Trips: ${v.tripsCompleted}',
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppStatusChip(status: v.status),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
