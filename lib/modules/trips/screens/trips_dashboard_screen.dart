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
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/trips_controller.dart';
import '../models/trips_analytics_model.dart';

class TripsDashboardScreen extends GetView<TripsController> {
  const TripsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Tours & Trips Management Portal',
      trailingHeader: AppButton(
        text: '+ Add Package',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/trips/packages/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(message: 'Loading Tours & Trips analytics...');
        }

        final a = controller.analytics.value;

        return RefreshIndicator(
          onRefresh: () async => controller.loadDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-navigation bar
                _buildSubNav(),
                const SizedBox(height: AppDimensions.spaceLg),

                // Top KPI Metrics Grid (8 Core Metrics)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 1100;
                    final isMedium = constraints.maxWidth > 700;
                    final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.6 : (isMedium ? 1.8 : 2.2),
                      children: [
                        AppKpiCard(
                          title: 'Total Tour Packages',
                          value: '${a?.totalPackages ?? 0}',
                          subtitle: '${a?.activePackages ?? 0} Live • ${a?.pendingApproval ?? 0} In Review',
                          icon: Icons.luggage_rounded,
                          color: AppColors.tripsService,
                          trendBadge: 'Catalog',
                          onTap: () => Get.toNamed('/trips/packages'),
                        ),
                        AppKpiCard(
                          title: 'Total Passengers Served',
                          value: '${a?.totalCustomers ?? 0}',
                          subtitle: 'Verified travelers across tours',
                          icon: Icons.groups_rounded,
                          color: const Color(0xFF0284C7),
                          trendBadge: '+24.1%',
                        ),
                        AppKpiCard(
                          title: 'Upcoming Scheduled Trips',
                          value: '${a?.upcomingTrips ?? 0}',
                          subtitle: 'Departures next 30 days',
                          icon: Icons.departure_board_rounded,
                          color: AppColors.primary,
                          trendBadge: 'Active',
                        ),
                        AppKpiCard(
                          title: 'Package Gross Revenue',
                          value: Formatters.currency(a?.totalRevenue ?? 0),
                          subtitle: 'Pending payout: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                          trendBadge: '+16.8%',
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Revenue Trends & Booking Status Breakdown
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
                              title: 'Trip Revenue Trends (Past 6 Months)',
                              subtitle: 'Gross package ticket bookings (INR)',
                              child: AppLineChart(
                                dataPoints: a?.revenueTrends ?? [],
                                primaryColor: AppColors.tripsService,
                                valueFormatter: (v) => Formatters.currency(v),
                                height: 260,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: AppCard(
                              title: 'Booking Status Distribution',
                              subtitle: 'Passenger reservation breakdown',
                              child: AppDonutChart(
                                slices: a?.bookingStatusBreakdown ?? [],
                                centerLabel: 'Trips',
                                centerValue: '${a?.totalBookings ?? 0}',
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
                            title: 'Trip Revenue Trends (Past 6 Months)',
                            subtitle: 'Gross package ticket bookings (INR)',
                            child: AppLineChart(
                              dataPoints: a?.revenueTrends ?? [],
                              primaryColor: AppColors.tripsService,
                              valueFormatter: (v) => Formatters.currency(v),
                              height: 240,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                          AppCard(
                            title: 'Booking Status Distribution',
                            subtitle: 'Passenger reservation breakdown',
                            child: AppDonutChart(
                              slices: a?.bookingStatusBreakdown ?? [],
                              centerLabel: 'Trips',
                              centerValue: '${a?.totalBookings ?? 0}',
                              height: 240,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Weekly Booking Volume Bar Chart
                AppCard(
                  title: 'Daily Passenger Reservations (Past 7 Days)',
                  subtitle: 'Confirmed passenger seats booked per day',
                  child: AppBarChart(
                    groups: a?.bookingTrends ?? [],
                    barColor: AppColors.tripsService,
                    height: 220,
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Recent Bookings Table
                AppCard(
                  title: 'Recent Passenger Bookings',
                  subtitle: 'Confirmed and incoming travel reservations',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/bookings'),
                    child: const Text('View All Bookings'),
                  ),
                  child: _buildRecentBookingsTable(a?.recentBookings ?? []),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Package Performance List
                AppCard(
                  title: 'Package Performance & Popularity',
                  subtitle: 'Passenger booking volume and revenue generated per package',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/trips/packages'),
                    child: const Text('Manage Packages'),
                  ),
                  child: _buildPackagePerformanceList(a?.packagePerformances ?? []),
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
            avatar: const Icon(Icons.luggage_rounded, size: 16, color: AppColors.tripsService),
            label: const Text('Trip Packages Catalog'),
            onPressed: () => Get.toNamed('/trips/packages'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.map_rounded, size: 16, color: AppColors.tripsService),
            label: const Text('Covered Destinations'),
            onPressed: () => Get.toNamed('/trips/destinations'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.timeline_rounded, size: 16, color: AppColors.tripsService),
            label: const Text('Day-wise Itineraries'),
            onPressed: () => Get.toNamed('/trips/itinerary'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsTable(List<TripBookingItemModel> bookings) {
    if (bookings.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No trip bookings found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('TOUR PACKAGE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('DEPARTURE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('PASSENGERS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ],
        rows: bookings.map((b) {
          return DataRow(
            cells: [
              DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(b.customerName)),
              DataCell(Text(b.packageTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5))),
              DataCell(Text(b.departureDate, style: const TextStyle(fontSize: 12))),
              DataCell(Text('${b.travelersCount} Travelers')),
              DataCell(Text(Formatters.currency(b.amount), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(AppStatusChip(status: b.status.name)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPackagePerformanceList(List<PackagePerformanceModel> performances) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: performances.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final p = performances[index];
        final isPending = p.status.contains('Pending');

        return Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isPending ? AppColors.warningLight : AppColors.tripsServiceBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPending ? Icons.hourglass_top_rounded : Icons.hiking_rounded,
                color: isPending ? AppColors.warning : AppColors.tripsService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text('${p.duration} • ★ ${p.rating} (${p.reviewsCount} reviews) • ${p.totalBookings} Bookings', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isPending)
                  Text(
                    Formatters.currency(p.revenue),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.tripsService),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPending ? AppColors.warningLight : AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p.status,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isPending ? AppColors.warning : AppColors.success,
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
