import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/trips_controller.dart';

class DestinationsScreen extends GetView<TripsController> {
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      {'name': 'Kaziranga National Park', 'state': 'Assam', 'packages': '2 Active Tours'},
      {'name': 'Majuli River Island', 'state': 'Assam', 'packages': '1 Active Tour'},
      {'name': 'Shillong & Cherrapunjee', 'state': 'Meghalaya', 'packages': '1 Active Tour'},
      {'name': 'Tawang Monastery Trail', 'state': 'Arunachal Pradesh', 'packages': 'Upcoming'},
    ];

    return MainLayout(
      title: 'Covered Destinations',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: AppCard(
          title: 'Regional Circuit & Hubs',
          subtitle: 'Destinations covered by your tour operator packages',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: destinations.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final d = destinations[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF3E8FF),
                  child: Icon(Icons.place_rounded, color: Colors.deepPurple, size: 20),
                ),
                title: Text(d['name']!, style: AppTextStyles.h4),
                subtitle: Text('State: ${d['state']}', style: AppTextStyles.caption),
                trailing: Chip(label: Text(d['packages']!)),
              );
            },
          ),
        ),
      ),
    );
  }
}
