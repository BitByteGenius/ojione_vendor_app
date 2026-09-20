import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/local_experiences_controller.dart';

class ScheduleScreen extends GetView<LocalExperiencesController> {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Experience Schedules & Slots',
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...controller.experiences.map((exp) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceLg),
                  child: AppCard(
                    title: exp.title,
                    subtitle: 'City: ${exp.city} • Capacity: ${exp.maxCapacity} Guests per session',
                    child: exp.schedules.isEmpty
                        ? const Text('No active scheduled slots for this experience.')
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exp.schedules.length,
                            separatorBuilder: (_, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final sch = exp.schedules[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withAlpha(25),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                      ),
                                      child: const Icon(Icons.access_time_rounded, color: Colors.teal, size: 20),
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
                                                  '${sch.startTime} - ${sch.endTime}',
                                                  style: AppTextStyles.h4,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.teal.withAlpha(25),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '${sch.availableSeats}/${sch.maxCapacity} Seats',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Days: ${sch.daysOfWeek.join(", ")}',
                                            style: AppTextStyles.caption,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
