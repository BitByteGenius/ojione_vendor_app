import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/trips_controller.dart';

class ItineraryScreen extends GetView<TripsController> {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Tour Itinerary Planner',
      body: Obx(() {
        final pkg = controller.selectedPackage.value ?? (controller.packages.isNotEmpty ? controller.packages.first : null);
        if (pkg == null) {
          return const Center(child: Text('No package selected'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                title: pkg.title,
                subtitle: '${pkg.durationDays} Days / ${pkg.durationNights} Nights Detailed Day-by-Day Schedule',
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pkg.itinerary.length,
                  separatorBuilder: (_, index) => const SizedBox(height: AppDimensions.spaceMd),
                  itemBuilder: (context, index) {
                    final day = pkg.itinerary[index];
                    return Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMd),
                      decoration: BoxDecoration(
                        color: AppColors.tripsServiceBg.withAlpha(50),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        border: Border.all(color: AppColors.tripsService.withAlpha(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tripsService,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('DAY ${day.dayNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              const SizedBox(width: AppDimensions.spaceSm),
                              Expanded(child: Text(day.title, style: AppTextStyles.h4)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(day.description, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: day.activities
                                .map((a) => Chip(
                                      label: Text(a, style: const TextStyle(fontSize: 11)),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 4),
                          Text('Meals included: ${day.mealsIncluded}', style: AppTextStyles.caption),
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
