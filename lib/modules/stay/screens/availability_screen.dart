import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../widgets/availability_calendar.dart';

class StayAvailabilityScreen extends GetView<StayController> {
  const StayAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Stay Availability & Blackout Dates',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              title: '7-Day Room Inventory Forecast',
              subtitle: 'Monitor open inventory and block dates for private booking or maintenance',
              child: Obx(() {
                return StayAvailabilityCalendarWidget(
                  availabilityList: controller.availabilityList,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
