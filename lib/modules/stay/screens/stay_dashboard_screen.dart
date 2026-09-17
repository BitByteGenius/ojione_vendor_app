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
import '../controllers/stay_controller.dart';
import '../models/stay_analytics_model.dart';

class StayDashboardScreen extends GetView<StayController> {
  const StayDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Stay & Accommodation Portal',
      trailingHeader: AppButton(
        text: '+ Add Property',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/stay/properties/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(message: 'Loading Stay analytics & inventory...');
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
                // Quick Sub-Navigation Toolbar
                _buildSubNavToolbar(),
                const SizedBox(height: AppDimensions.spaceLg),

                // Top KPI Metrics Row (10 Core Stay Metrics)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 1100;
                    final isMedium = constraints.maxWidth > 700;
                    final crossAxisCount = isWide ? 5 : (isMedium ? 3 : 2);

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.6 : (isMedium ? 1.5 : 1.3),
                      children: [
                        AppKpiCard(
                          title: 'Total Properties',
                          value: '${a?.totalProperties ?? 0}',
                          subtitle: '${a?.activeProperties ?? 0} Live • ${a?.pendingApproval ?? 0} Review',
                          icon: Icons.apartment_rounded,
                          color: AppColors.stayService,
                          trendBadge: 'Active',
                          isPositiveTrend: true,
                          onTap: () => Get.toNamed('/stay/properties'),
                        ),
                        AppKpiCard(
                          title: 'Total Live Rooms',
                          value: '${a?.totalRooms ?? 0}',
                          subtitle: 'Across listed properties',
                          icon: Icons.bed_rounded,
                          color: const Color(0xFF0284C7),
                          trendBadge: 'Inventory',
                          isPositiveTrend: true,
                          onTap: () => Get.toNamed('/stay/rooms'),
                        ),
                        AppKpiCard(
                          title: "Today's Bookings",
                          value: '${a?.todayBookings ?? 0}',
                          subtitle: 'Check-ins scheduled',
                          icon: Icons.today_rounded,
                          color: AppColors.primary,
                          trendBadge: '+18.5%',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Upcoming Bookings',
                          value: '${a?.upcomingBookings ?? 0}',
                          subtitle: 'Next 14 days reserved',
                          icon: Icons.event_available_rounded,
                          color: const Color(0xFF7C3AED),
                          trendBadge: 'Booked',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Total Revenue',
                          value: Formatters.currency(a?.totalRevenue ?? 0),
                          subtitle: 'Payout due: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                          trendBadge: '+12.4%',
                          isPositiveTrend: true,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Occupancy Health Highlight Bar (Mobile-optimized vertical card)
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
                            'Average Occupancy Rate',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.stayService.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${a?.occupancyRate ?? 0}% Optimal',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.stayService, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AppProgressBar(
                        percentage: a?.occupancyRate ?? 0,
                        progressColor: AppColors.stayService,
                        height: 8,
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pending Approvals', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(
                            '${a?.pendingApproval ?? 0} Property in Review',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.warning),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Charts Section: Revenue Overview & Booking Trends & Donut
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
                              title: 'Monthly Revenue Overview',
                              subtitle: 'Gross room bookings revenue trend (INR)',
                              child: AppLineChart(
                                dataPoints: a?.revenueOverview ?? [],
                                primaryColor: AppColors.stayService,
                                valueFormatter: (v) => Formatters.currency(v),
                                height: 260,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: AppCard(
                              title: 'Booking Status Breakdown',
                              subtitle: 'Status distribution for stay bookings',
                              child: AppDonutChart(
                                slices: a?.bookingStatusBreakdown ?? [],
                                centerLabel: 'Bookings',
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
                            title: 'Monthly Revenue Overview',
                            subtitle: 'Gross room bookings revenue trend (INR)',
                            child: AppLineChart(
                              dataPoints: a?.revenueOverview ?? [],
                              primaryColor: AppColors.stayService,
                              valueFormatter: (v) => Formatters.currency(v),
                              height: 240,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                          AppCard(
                            title: 'Booking Status Breakdown',
                            subtitle: 'Status distribution for stay bookings',
                            child: AppDonutChart(
                              slices: a?.bookingStatusBreakdown ?? [],
                              centerLabel: 'Bookings',
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

                // Weekly Booking Trends Bar Chart
                AppCard(
                  title: 'Daily Booking Volume (Past 7 Days)',
                  subtitle: 'Number of check-ins confirmed per day of week',
                  child: AppBarChart(
                    groups: a?.bookingTrends ?? [],
                    barColor: AppColors.stayService,
                    height: 220,
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Recent Bookings Table
                AppCard(
                  title: 'Recent Stay Reservations',
                  subtitle: 'Latest guest check-ins and reservation requests',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/bookings'),
                    child: const Text('View All Bookings'),
                  ),
                  child: _buildRecentBookingsTable(a?.recentBookings ?? []),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Property Performance & Recent Reviews Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 950;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildPropertyPerformanceCard(a?.propertyPerformances ?? []),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: _buildRecentReviewsCard(a?.recentReviews ?? []),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildPropertyPerformanceCard(a?.propertyPerformances ?? []),
                          const SizedBox(height: AppDimensions.spaceLg),
                          _buildRecentReviewsCard(a?.recentReviews ?? []),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubNavToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.list_alt_rounded, size: 16, color: AppColors.stayService),
            label: const Text('Properties Catalog'),
            onPressed: () => Get.toNamed('/stay/properties'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.bed_outlined, size: 16, color: AppColors.stayService),
            label: const Text('Rooms & Units Inventory'),
            onPressed: () => Get.toNamed('/stay/rooms'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.stayService),
            label: const Text('Availability & Calendar'),
            onPressed: () => Get.toNamed('/stay/availability'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.sell_outlined, size: 16, color: AppColors.stayService),
            label: const Text('Pricing & Tariffs'),
            onPressed: () => Get.toNamed('/stay/pricing'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsTable(List<StayBookingItemModel> bookings) {
    if (bookings.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No bookings found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('GUEST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('PROPERTY & ROOM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('DATES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ],
        rows: bookings.map((b) {
          return DataRow(
            cells: [
              DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(b.guestName)),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(b.propertyName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                    Text(b.roomType, style: AppTextStyles.caption),
                  ],
                ),
              ),
              DataCell(Text('${b.checkIn} → ${b.checkOut} (${b.nights}N)', style: const TextStyle(fontSize: 12))),
              DataCell(Text(Formatters.currency(b.amount), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(AppStatusChip(status: b.status.name)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPropertyPerformanceCard(List<PropertyPerformanceModel> performances) {
    return AppCard(
      title: 'Property Performance & Occupancy',
      subtitle: 'Occupancy and revenue metrics per accommodation property',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: performances.length,
        separatorBuilder: (_, _) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final p = performances[index];
          final isPending = p.approvalStatus.contains('Pending');

          return Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isPending ? AppColors.warningLight : AppColors.stayServiceBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPending ? Icons.hourglass_top_rounded : Icons.apartment_rounded,
                  color: isPending ? AppColors.warning : AppColors.stayService,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p.propertyType} • ${p.totalRooms} Rooms • ★ ${p.rating}',
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isPending) ...[
                      const SizedBox(height: 4),
                      AppProgressBar(
                        percentage: p.occupancyPercentage,
                        progressColor: AppColors.stayService,
                        height: 5,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isPending)
                    Text(
                      Formatters.currency(p.monthRevenue),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.stayService),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPending ? AppColors.warningLight : AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPending ? 'Under Review' : '${p.occupancyPercentage}% Occ',
                      style: TextStyle(
                        fontSize: 10,
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
      ),
    );
  }

  Widget _buildRecentReviewsCard(List<StayReviewModel> reviews) {
    return AppCard(
      title: 'Recent Guest Reviews',
      subtitle: 'Guest ratings and feedback',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.length,
        separatorBuilder: (_, _) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final r = reviews[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.guestName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      Text(' ${r.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text('${r.propertyName} • ${r.date}', style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text('"${r.comment}"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ],
          );
        },
      ),
    );
  }
}
