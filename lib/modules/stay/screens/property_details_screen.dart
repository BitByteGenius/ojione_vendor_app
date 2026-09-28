import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';
import '../models/property_model.dart';
import '../widgets/property_status_chip.dart';
import '../widgets/room_card.dart';

class PropertyDetailsScreen extends GetView<StayController> {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyModel prop = Get.arguments as PropertyModel? ??
        controller.selectedProperty.value ??
        (controller.properties.isNotEmpty ? controller.properties.first : _fallbackProperty());

    return MainLayout(
      title: prop.name,
      trailingHeader: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PropertyStatusChip(status: prop.status),
          const SizedBox(width: AppDimensions.spaceSm),
          AppButton(
            text: 'Edit',
            icon: Icons.edit_outlined,
            height: AppDimensions.buttonHeightSm,
            type: AppButtonType.outline,
            onPressed: () => Get.toNamed('/stay/properties/add'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover & Images Gallery Preview
            if (prop.images.isNotEmpty) ...[
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  image: DecorationImage(
                    image: NetworkImage(prop.images.first.url),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceMd),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prop.name,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prop.propertyType} • ${prop.city}, ${prop.state}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.photo_library_outlined, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${prop.images.length} Photos',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
            ],

            // Property Overview Card
            AppCard(
              title: 'Property Overview',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prop.description, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${prop.address}, ${prop.city}, ${prop.state} - ${prop.pincode}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Check-in: ${prop.checkInTime} • Check-out: ${prop.checkOutTime}',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // Pricing & Furnishing Card
            AppCard(
              title: 'Pricing & Furnishing Details',
              child: Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  _buildDetailBadge(
                    'Nightly Rate',
                    '${Formatters.currency(prop.basePricePerNight)} / night',
                    Icons.payments_rounded,
                  ),
                  if (prop.pricePerMonth != null || prop.displayPricePerMonth > 0)
                    _buildDetailBadge(
                      'Monthly Rent',
                      '${Formatters.currency(prop.displayPricePerMonth)} / month',
                      Icons.calendar_month_rounded,
                    ),
                  if (prop.depositAmount != null)
                    _buildDetailBadge(
                      'Security Deposit',
                      Formatters.currency(prop.depositAmount!),
                      Icons.savings_rounded,
                    ),
                  if (prop.furnishingStatus != null)
                    _buildDetailBadge(
                      'Furnishing',
                      prop.furnishingStatus!,
                      Icons.chair_rounded,
                    ),
                  _buildDetailBadge(
                    'Available Units',
                    '${prop.availableRooms} Units',
                    Icons.meeting_room_rounded,
                  ),
                  _buildDetailBadge(
                    'Max Occupancy',
                    '${prop.maxOccupancy} Guests/unit',
                    Icons.people_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // Amenities & House Rules Card
            if (prop.amenities.isNotEmpty || prop.houseRules.isNotEmpty) ...[
              AppCard(
                title: 'Amenities & House Rules',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (prop.amenities.isNotEmpty) ...[
                      const Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: prop.amenities.map((a) {
                          return Chip(
                            avatar: const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                            label: Text(a.name, style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppColors.primaryLight,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (prop.houseRules.isNotEmpty) ...[
                      const Text('House Rules & Policies:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: prop.houseRules.map((rule) {
                          return Chip(
                            avatar: const Icon(Icons.rule_rounded, size: 14, color: Colors.indigo),
                            label: Text(rule, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.indigo.shade50,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
            ],

            // Rooms & Inventories Card
            AppCard(
              title: 'Rooms & Inventories (${prop.rooms.length})',
              trailing: AppButton(
                text: '+ Add Room',
                height: AppDimensions.buttonHeightSm,
                onPressed: () {},
              ),
              child: prop.rooms.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No room sub-units defined. Listing operates as a single inventory unit.'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: prop.rooms.length,
                      separatorBuilder: (_, index) => const SizedBox(height: AppDimensions.spaceSm),
                      itemBuilder: (context, index) {
                        return RoomCard(room: prop.rooms[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBadge(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  static PropertyModel _fallbackProperty() {
    return PropertyModel(
      id: 'prop-fallback',
      name: 'Sample Stay Property',
      description: 'Standard property overview.',
      propertyType: 'Homestay',
      address: 'Main Street',
      city: 'Guwahati',
      state: 'Assam',
      pincode: '781001',
      status: 'published',
      basePricePerNight: 2000,
      rooms: [],
      amenities: [],
      images: [],
      createdAt: DateTime.now(),
    );
  }
}
