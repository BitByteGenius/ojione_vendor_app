import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../controllers/vendor_home_controller.dart';
import '../widgets/demo_vendor_switcher_modal.dart';

class ServicesHubScreen extends GetView<VendorHomeController> {
  const ServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'My Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
            tooltip: 'Switch Demo Vendor',
            onPressed: () => DemoVendorSwitcherModal.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final assigned = auth.assignedServices.toList();

          if (assigned.isEmpty) {
            return const AppEmptyState(
              title: 'No Registered Services',
              message: 'You have not registered for any services yet.',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Each service has an independent dashboard and operational environment.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                Text(
                  'Active Services (${assigned.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Grid / List of active services
                ...assigned.map((service) => _buildServiceTile(context, service)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, ServiceType service) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.openServiceDashboard(service),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: service.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(service.icon, size: 28, color: service.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.displayName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.description,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Feature tags for the service
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _getServiceFeatures(service).map((feat) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feat,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getServiceFeatures(ServiceType service) {
    switch (service) {
      case ServiceType.stay:
        return ['Properties', 'Rooms', 'Occupancy', 'Calendar', 'Pricing'];
      case ServiceType.trips:
        return ['Tour Packages', 'Itineraries', 'Destinations', 'Bookings'];
      case ServiceType.shop:
        return ['Products', 'Inventory', 'Orders', 'Returns'];
      case ServiceType.rental:
        return ['Vehicles', 'Fleet Utilization', 'Maintenance', 'Rentals'];
      case ServiceType.localExperiences:
        return ['Workshops', 'Schedules', 'Capacity', 'Attendees'];
    }
  }
}
