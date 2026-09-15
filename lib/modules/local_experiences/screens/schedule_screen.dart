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
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.access_time_rounded, color: Colors.teal),
                                title: Text('${sch.startTime} - ${sch.endTime}', style: AppTextStyles.h4),
                                subtitle: Text('Days: ${sch.daysOfWeek.join(", ")}', style: AppTextStyles.caption),
                                trailing: Chip(
                                  label: Text('${sch.availableSeats} / ${sch.maxCapacity} Seats Open'),
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
