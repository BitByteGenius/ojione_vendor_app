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
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final v = controller.vehicles[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.directions_car_rounded, color: Colors.blueAccent),
                  title: Text(v.displayName, style: AppTextStyles.h4),
                  subtitle: Text('City: ${v.operatingCity} • Completed Trips: ${v.tripsCompleted}', style: AppTextStyles.caption),
                  trailing: AppStatusChip(status: v.status),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
