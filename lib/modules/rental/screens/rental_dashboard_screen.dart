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
import '../../../../shared/widgets/charts/app_bar_chart.dart';
import '../../../../shared/widgets/charts/app_donut_chart.dart';
import '../../../../shared/widgets/charts/app_kpi_card.dart';
import '../../../../shared/widgets/charts/app_line_chart.dart';
import '../../../../shared/widgets/charts/app_progress_bar.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/rental_controller.dart';
import '../models/rental_analytics_model.dart';
import '../models/vehicle_model.dart';

class RentalDashboardScreen extends GetView<RentalController> {
  const RentalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Vehicle Rental Vendor Portal',
      trailingHeader: AppButton(
        text: '+ Add Vehicle',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/rental/vehicles/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(message: 'Loading Rental fleet analytics...');
        }

        final a = controller.analytics.value;

        return RefreshIndicator(
          onRefresh: () async => controller.loadRentalData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-navigation toolbar
                _buildSubNav(),
                const SizedBox(height: AppDimensions.spaceLg),

                // Top KPI Metrics Grid (8 Core Metrics)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 1100;
                    final isMedium = constraints.maxWidth > 700;
                    final crossAxisCount = isWide ? 4 : (isMedium ? 3 : 2);

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.6 : (isMedium ? 1.5 : 1.3),
                      children: [
                        AppKpiCard(
                          title: 'Total Fleet Size',
                          value: '${a?.totalVehicles ?? 0}',
                          subtitle: '${a?.availableVehicles ?? 0} Ready • ${a?.inMaintenance ?? 0} Maint',
                          icon: Icons.directions_car_rounded,
                          color: AppColors.rentalService,
                          trendBadge: 'Fleet',
                          onTap: () => Get.toNamed('/rental/vehicles'),
                        ),
                        AppKpiCard(
                          title: 'Currently Rented Out',
                          value: '${a?.currentlyRented ?? 0} Vehicles',
                          subtitle: 'On road with customers',
                          icon: Icons.key_rounded,
                          color: const Color(0xFF0284C7),
                          trendBadge: 'On Road',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Upcoming Bookings',
                          value: '${a?.upcomingBookings ?? 0}',
                          subtitle: 'Total bookings: ${a?.totalBookings ?? 0}',
                          icon: Icons.calendar_today_rounded,
                          color: AppColors.primary,
                          trendBadge: '+16.3%',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Rental Gross Revenue',
                          value: Formatters.currency(a?.totalRevenue ?? 0),
                          subtitle: 'Pending payout: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                          trendBadge: '+11.8%',
                          isPositiveTrend: true,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Vehicle Fleet Utilization Rate Bar (Mobile-optimized vertical card)
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Fleet Utilization Rate',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.rentalService.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${a?.utilizationRate ?? 0}% Utilization',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.rentalService, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AppProgressBar(
                        percentage: a?.utilizationRate ?? 0,
                        progressColor: AppColors.rentalService,
                        height: 8,
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Fleet Status', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(
                            '${a?.availableVehicles ?? 0} Available for Dispatch',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Revenue Trends & Fleet Status Donut Chart
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 950;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: AppCard(
                              title: 'Rental Revenue Overview (Past 6 Months)',
                              subtitle: 'Vehicle rental billings (INR)',
                              child: AppLineChart(
                                dataPoints: a?.revenueOverview ?? [],
                                primaryColor: AppColors.rentalService,
                                valueFormatter: (v) => Formatters.currency(v),
                                height: 260,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: AppCard(
                              title: 'Fleet Status Breakdown',
                              subtitle: 'Real-time vehicle availability distribution',
                              child: AppDonutChart(
                                slices: a?.fleetStatusBreakdown ?? [],
                                centerLabel: 'Fleet',
                                centerValue: '${a?.totalVehicles ?? 0}',
                                height: 260,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          AppCard(
                            title: 'Rental Revenue Overview (Past 6 Months)',
                            subtitle: 'Vehicle rental billings (INR)',
                            child: AppLineChart(
                              dataPoints: a?.revenueOverview ?? [],
                              primaryColor: AppColors.rentalService,
                              valueFormatter: (v) => Formatters.currency(v),
                              height: 240,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                          AppCard(
                            title: 'Fleet Status Breakdown',
                            subtitle: 'Real-time vehicle availability distribution',
                            child: AppDonutChart(
                              slices: a?.fleetStatusBreakdown ?? [],
                              centerLabel: 'Fleet',
                              centerValue: '${a?.totalVehicles ?? 0}',
                              height: 240,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Daily Rental Trends Bar Chart
                AppCard(
                  title: 'Daily Rental Check-Outs (Past 7 Days)',
                  subtitle: 'Number of vehicles picked up per day',
                  child: AppBarChart(
                    groups: a?.rentalTrends ?? [],
                    barColor: AppColors.rentalService,
                    height: 220,
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Recent Rental Bookings Table
                AppCard(
                  title: 'Recent Vehicle Rental Bookings',
                  subtitle: 'Customer vehicle reservations and trip dispatch logs',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/bookings'),
                    child: const Text('View All Bookings'),
                  ),
                  child: _buildRecentBookingsTable(a?.recentBookings ?? []),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Active Vehicles List
                AppCard(
                  title: 'Registered Fleet Inventory',
                  subtitle: 'Live vehicles available for booking with fuel and transmission details',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/rental/vehicles'),
                    child: const Text('Manage Fleet'),
                  ),
                  child: _buildFleetList(controller.vehicles),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubNav() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.directions_car_filled_outlined, size: 16, color: AppColors.rentalService),
            label: const Text('Vehicles Fleet Catalog'),
            onPressed: () => Get.toNamed('/rental/vehicles'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.event_available_outlined, size: 16, color: AppColors.rentalService),
            label: const Text('Availability & Booking Calendar'),
            onPressed: () => Get.toNamed('/rental/availability'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.currency_rupee_rounded, size: 16, color: AppColors.rentalService),
            label: const Text('Tariffs & Security Deposit'),
            onPressed: () => Get.toNamed('/rental/pricing'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsTable(List<RentalBookingItemModel> bookings) {
    if (bookings.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No rental bookings found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('VEHICLE & REG #', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('RENTAL DATES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ],
        rows: bookings.map((b) {
          return DataRow(
            cells: [
              DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(b.customerName)),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(b.vehicleName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                    Text(b.registrationNumber, style: AppTextStyles.caption),
                  ],
                ),
              ),
              DataCell(Text(b.rentalDates, style: const TextStyle(fontSize: 12))),
              DataCell(Text(Formatters.currency(b.amount), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(AppStatusChip(status: b.status.name)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFleetList(List<VehicleModel> list) {
    if (list.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No vehicles added yet.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final v = list[index];
        final isRented = v.status == 'rented';

        return Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isRented ? const Color(0xFFFEF3C7) : AppColors.rentalServiceBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                v.category.contains('Motorcycle') ? Icons.two_wheeler_rounded : Icons.directions_car_rounded,
                color: isRented ? const Color(0xFFD97706) : AppColors.rentalService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${v.make} ${v.modelName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${v.registrationNumber} • ${v.category} • ${v.transmission} • ${v.fuelType}',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${Formatters.currency(v.pricePerDay)}/day',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.rentalService),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRented ? const Color(0xFFFEF3C7) : AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isRented ? 'Currently Rented' : 'Available',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isRented ? const Color(0xFFD97706) : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
