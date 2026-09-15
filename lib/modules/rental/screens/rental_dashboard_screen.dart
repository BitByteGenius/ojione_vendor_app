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
import '../controllers/rental_controller.dart';

class RentalDashboardScreen extends GetView<RentalController> {
  const RentalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Vehicle Rental Fleet',
      trailingHeader: AppButton(
        text: '+ Add Vehicle',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/rental/vehicles/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.vehicles.isEmpty) {
          return const AppLoader(message: 'Loading rental fleet...');
        }

        final cityOptions = ['All Cities', ...controller.cities];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Backend-driven city filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cityOptions.map((city) {
                    final isSel = controller.selectedCityFilter.value == city;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                      child: ChoiceChip(
                        avatar: const Icon(Icons.location_city_rounded, size: 16),
                        label: Text(city),
                        selected: isSel,
                        selectedColor: AppColors.rentalService,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => controller.selectedCityFilter.value = city,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Vehicles List
              AppCard(
                title: 'Fleet Inventory & Operational Status',
                subtitle: 'Manage self-drive and chauffeur vehicles by operating cities',
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredVehicles.length,
                  separatorBuilder: (_, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final v = controller.filteredVehicles[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.rentalServiceBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: const Icon(Icons.directions_car_rounded, color: AppColors.rentalService, size: 24),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text('${v.make} ${v.modelName}', style: AppTextStyles.h4)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              v.operatingCity.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text('Reg: ${v.registrationNumber} • ${v.category} • ${v.seatingCapacity} Seats • ${v.transmission} • ${v.fuelType}', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text('Mode: ${v.rentalType} • Security Deposit: ${Formatters.currency(v.securityDeposit)}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${Formatters.currency(v.pricePerDay)} / day', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                          AppStatusChip(status: v.status),
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
