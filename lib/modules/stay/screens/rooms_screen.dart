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
            // Property Selector Bar
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(
                    Icons.apartment_rounded,
                    color: AppColors.stayService,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Property:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedProp?.id,
                        isExpanded: true,
                        items: controller.properties.map((p) {
                          return DropdownMenuItem<String>(
                            value: p.id,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectedProperty.value = controller
                                .properties
                                .firstWhereOrNull((p) => p.id == val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: rooms.isEmpty
                  ? const Center(
                      child: Text('No rooms added to this property yet.'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppDimensions.spaceLg),
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
}
