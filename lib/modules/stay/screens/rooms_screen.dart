import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../widgets/room_card.dart';

class RoomsScreen extends GetView<StayController> {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Rooms & Units Inventory',
      subtitle: 'Manage property room inventory',
      showBackButton: true,

      body: Obx(() {
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return const AppLoader(message: 'Loading room inventory...');
        }

        if (controller.properties.isEmpty) {
          return const Center(
            child: Text('No properties available to display rooms.'),
          );
        }

        // Auto-select first property if none selected
        if (controller.selectedProperty.value == null &&
            controller.properties.isNotEmpty) {
          controller.selectedProperty.value = controller.properties.first;
        }

        final selectedProp = controller.selectedProperty.value;
        final rooms = selectedProp?.rooms ?? [];

        return Column(
          children: [
            // Modern Mobile Property Picker Tile
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => _showPropertyPickerSheet(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.stayServiceBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.apartment_rounded,
                            color: AppColors.stayService,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SELECTED PROPERTY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                selectedProp?.name ?? 'Select Property',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Switch',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.unfold_more_rounded,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Rooms Count Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room Units (${rooms.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${rooms.where((r) => r.isAvailable).length} Active',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.stayService,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Room List
            Expanded(
              child: rooms.isEmpty
                  ? const Center(
                      child: Text('No rooms added to this property yet.'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.spaceMd,
                        0,
                        AppDimensions.spaceMd,
                        AppDimensions.spaceLg,
                      ),
                      itemCount: rooms.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: AppDimensions.spaceMd),
                      itemBuilder: (context, index) {
                        return RoomCard(room: rooms[index]);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _showPropertyPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Property',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: controller.properties.map((p) {
                        final isSelected =
                            controller.selectedProperty.value?.id == p.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.stayServiceBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.stayService.withAlpha(80)
                                  : Colors.transparent,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.stayService
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.apartment_rounded,
                                color: isSelected ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              p.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.stayService
                                    : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${p.rooms.length} Room types • ${p.city}, ${p.state}',
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.stayService,
                                  )
                                : null,
                            onTap: () {
                              controller.selectedProperty.value = p;
                              Navigator.pop(ctx);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
