import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      trailingHeader: AppButton(
        text: '+ Add Room',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () {},
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();

        final prop = controller.selectedProperty.value;
        final rooms = prop?.rooms ?? [];

        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spaceMd),
          itemBuilder: (context, index) {
            return RoomCard(room: rooms[index]);
          },
        );
      }),
    );
  }
}
