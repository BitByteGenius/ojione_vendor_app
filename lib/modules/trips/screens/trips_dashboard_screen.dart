import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/trips_controller.dart';

class TripsDashboardScreen extends GetView<TripsController> {
  const TripsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Tours & Trips Management',
      trailingHeader: AppButton(
        text: '+ Add Package',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/trips/packages/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.packages.isEmpty) {
          return const AppLoader(message: 'Loading tour packages...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sub navigation
              Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.luggage_rounded, size: 16),
                    label: const Text('Trip Packages'),
                    onPressed: () => Get.toNamed('/trips/packages'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.map_rounded, size: 16),
                    label: const Text('Covered Destinations'),
                    onPressed: () => Get.toNamed('/trips/destinations'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.timeline_rounded, size: 16),
                    label: const Text('Day-wise Itineraries'),
                    onPressed: () => Get.toNamed('/trips/itinerary'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Packages Grid / List
              AppCard(
                title: 'Available Tour & Sightseeing Packages',
                subtitle: 'Manage destinations, schedules, pricing inclusions and passenger bookings',
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.packages.length,
                  separatorBuilder: (_, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final p = controller.packages[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.tripsServiceBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: const Icon(Icons.hiking_rounded, color: AppColors.tripsService, size: 24),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(p.title, style: AppTextStyles.h4)),
                          AppStatusChip(status: p.status),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${p.durationDays} Days / ${p.durationNights} Nights • Destinations: ${p.destinations.join(", ")}', style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${Formatters.currency(p.pricePerPerson)} / person',
                            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                          ),
                          Text('★ ${p.rating} (${p.reviewsCount} reviews)', style: AppTextStyles.caption),
                        ],
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
