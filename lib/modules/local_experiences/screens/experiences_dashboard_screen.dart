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
import '../controllers/local_experiences_controller.dart';

class ExperiencesDashboardScreen extends GetView<LocalExperiencesController> {
  const ExperiencesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Local Experiences & Activities',
      trailingHeader: AppButton(
        text: '+ Add Experience',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/experiences/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.experiences.isEmpty) {
          return const AppLoader(message: 'Loading local experiences...');
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
                    avatar: const Icon(Icons.local_activity_rounded, size: 16),
                    label: const Text('All Experiences'),
                    onPressed: () => Get.toNamed('/experiences/list'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_month_outlined, size: 16),
                    label: const Text('Schedules & Batches'),
                    onPressed: () => Get.toNamed('/experiences/schedule'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _stat('Total Experiences', '${controller.experiences.length}', Icons.local_activity_rounded, AppColors.localExpService),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _stat('Total Participants', '99', Icons.groups_rounded, AppColors.primary),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _stat('Avg. Rating', '4.9 ★', Icons.star_rounded, AppColors.secondary),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Experience Listings Card
              AppCard(
                title: 'Curated City Activities & Workshops',
                subtitle: 'Immersive regional culture, culinary classes, craft guilds, and nature walks',
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.experiences.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final exp = controller.experiences[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.localExpServiceBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: const Icon(Icons.local_activity_rounded, color: AppColors.localExpService, size: 24),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(exp.title, style: AppTextStyles.h4)),
                          AppStatusChip(status: exp.status),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text('${exp.category} • ${exp.city} • Duration: ${exp.durationHours} hrs • Max ${exp.maxCapacity} persons', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text('Meeting Point: ${exp.meetingPoint}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${Formatters.currency(exp.pricePerPerson)} / person', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                          Text('★ ${exp.rating} (${exp.reviewsCount} reviews)', style: AppTextStyles.caption),
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

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(30),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.h3.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
