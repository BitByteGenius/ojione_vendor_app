import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/bookings_controller.dart';

class BookingCalendarScreen extends GetView<BookingsController> {
  const BookingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Bookings Calendar & Schedule',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              title: 'Schedule Overview',
              subtitle: 'Active arrivals, trips, rentals, and experiences scheduled this week',
              child: Obx(() {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.bookings.length,
                  separatorBuilder: (_, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final b = controller.bookings[index];
                    return InkWell(
                      onTap: () => controller.selectBooking(b),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.spaceSm),
                              decoration: BoxDecoration(
                                color: b.serviceType.bgColor,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                              ),
                              child: Icon(b.serviceType.icon, color: b.serviceType.color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${b.itemName} — ${b.customerName}',
                                          style: AppTextStyles.h4,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      AppStatusChip(status: b.status.name),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Scheduled: ${Formatters.dateTime(b.startDate)} to ${Formatters.dateTime(b.endDate)}',
                                    style: AppTextStyles.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
