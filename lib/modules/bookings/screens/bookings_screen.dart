import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/bookings_controller.dart';
import '../models/booking_status_model.dart';

class BookingsScreen extends GetView<BookingsController> {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return MainLayout(
      title: 'Central Bookings',
      trailingHeader: IconButton(
        icon: const Icon(Icons.calendar_month_outlined),
        tooltip: 'Calendar View',
        onPressed: () => Get.toNamed('/bookings/calendar'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter by Service Row (Only active services enabled for vendor)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All Services'),
                      selected: controller.filter.value.serviceType == null,
                      onSelected: (_) => controller.filterByService(null),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    ...ServiceType.values
                        .where((s) => s != ServiceType.shop && auth.hasService(s))
                        .map((s) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                        child: ChoiceChip(
                          avatar: Icon(s.icon, size: 16, color: s.color),
                          label: Text(s.displayName),
                          selected: controller.filter.value.serviceType == s,
                          onSelected: (_) => controller.filterByService(s),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              // Filter by Status Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Statuses'),
                      selected: controller.filter.value.status == null,
                      onSelected: (_) => controller.filterByStatus(null),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    ...BookingStatus.values.map((st) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                        child: FilterChip(
                          label: Text(st.label),
                          selected: controller.filter.value.status == st,
                          onSelected: (_) => controller.filterByStatus(st),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Bookings Table / List
              if (controller.isLoading.value)
                const AppLoader(message: 'Loading bookings...')
              else if (controller.bookings.isEmpty)
                const AppEmptyState(
                  icon: Icons.calendar_today_outlined,
                  title: 'No Bookings Found',
                  message: 'No reservations match your current filter settings.',
                )
              else
                AppCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.bookings.length,
                    separatorBuilder: (_, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final b = controller.bookings[index];
                      return InkWell(
                        onTap: () => controller.selectBooking(b),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  b.bookingReference,
                                                  style: AppTextStyles.h4,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                                decoration: BoxDecoration(
                                                  color: b.serviceType.bgColor,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  b.serviceType.displayName,
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: b.serviceType.color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Formatters.currency(b.totalAmount),
                                          style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      b.itemName,
                                      style: AppTextStyles.bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${b.customerName} • ${Formatters.date(b.startDate)}',
                                            style: AppTextStyles.caption,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AppStatusChip(status: b.status.name),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
