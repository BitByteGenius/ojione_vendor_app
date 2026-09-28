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
      title: 'Stay & Accommodation',
      subtitle: 'Vendor Management Portal',
      showBackButton: true,
      showNotificationBell: true,
      trailingHeader: AppButton(
        text: 'Add Property',
        icon: Icons.add_rounded,
        height: 36,
        onPressed: () => Get.toNamed('/stay/properties/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(
            message: 'Loading Stay analytics & inventory...',
          );
        }

        final a = controller.analytics.value;

        return RefreshIndicator(
          onRefresh: () async => controller.loadDashboardData(),
          color: AppColors.stayService,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Welcome & Status Banner
                _buildStayOverviewHeader(a),
                const SizedBox(height: AppDimensions.spaceMd),

                // 2. Quick Actions Grid
                _buildQuickActionsSection(),
                const SizedBox(height: AppDimensions.spaceLg),

                // 3. Top KPI Metrics (Responsive & Overflow-Free Grid)
                _buildKpiMetricsGrid(a),
                const SizedBox(height: AppDimensions.spaceLg),

                // 4. Occupancy Health & Pending Approvals
                _buildOccupancyHealthCard(a),
                const SizedBox(height: AppDimensions.spaceLg),

                // 5. Analytics Charts (Revenue Line Chart & Status Donut Chart)
                _buildAnalyticsChartsSection(a),
                const SizedBox(height: AppDimensions.spaceLg),

                // 6. Daily Booking Volume Bar Chart
                AppCard(
                  title: 'Daily Booking Volume (Past 7 Days)',
                  subtitle: 'Confirmed check-ins per day of week',
                  child: AppBarChart(
                    groups: a?.bookingTrends ?? [],
                    barColor: AppColors.stayService,
                    height: 200,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // 7. Recent Reservations Section
                _buildRecentReservationsCard(a?.recentBookings ?? []),
                const SizedBox(height: AppDimensions.spaceLg),

                // 8. Property Performance & Guest Reviews Section
                _buildPerformanceAndReviewsSection(a),
                const SizedBox(height: AppDimensions.spaceXl),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Welcome & Overview Banner Card
  Widget _buildStayOverviewHeader(StayDashboardAnalytics? a) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stay & Lodging Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${a?.activeProperties ?? 0} Live Properties • ${a?.totalRooms ?? 0} Total Rooms',
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'PORTAL LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Quick Actions Navigation Grid
  Widget _buildQuickActionsSection() {
    final actions = [
      _QuickActionItem(
        icon: Icons.list_alt_rounded,
        title: 'Properties',
        subtitle: 'Catalog',
        color: AppColors.stayService,
        route: '/stay/properties',
      ),
      _QuickActionItem(
        icon: Icons.king_bed_rounded,
        title: 'Rooms',
        subtitle: 'Inventory',
        color: const Color(0xFF0284C7),
        route: '/stay/rooms',
      ),
      _QuickActionItem(
        icon: Icons.calendar_month_rounded,
        title: 'Calendar',
        subtitle: 'Availability',
        color: const Color(0xFF7C3AED),
        route: '/stay/availability',
      ),
      _QuickActionItem(
        icon: Icons.sell_rounded,
        title: 'Tariffs',
        subtitle: 'Pricing',
        color: AppColors.secondary,
        route: '/stay/pricing',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Operations',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children:
              actions.map((item) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: _buildQuickActionCard(item),
                    ),
                  );
                }).toList()
                ..last = Expanded(child: _buildQuickActionCard(actions.last)),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(_QuickActionItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(item.route),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// KPI Metrics Grid (Designed to avoid pixel overflow on small screens)
  Widget _buildKpiMetricsGrid(StayDashboardAnalytics? a) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final isMedium = constraints.maxWidth > 600;

        final cards = [
          _StayKpiData(
            title: 'Total Properties',
            value: '${a?.totalProperties ?? 0}',
            subtitle:
                '${a?.activeProperties ?? 0} Live • ${a?.pendingApproval ?? 0} Review',
            icon: Icons.apartment_rounded,
            color: AppColors.stayService,
            badge: 'Active',
            onTap: () => Get.toNamed('/stay/properties'),
          ),
          _StayKpiData(
            title: 'Total Live Rooms',
            value: '${a?.totalRooms ?? 0}',
            subtitle: 'Across listed properties',
            icon: Icons.king_bed_rounded,
            color: const Color(0xFF0284C7),
            badge: 'Inventory',
            onTap: () => Get.toNamed('/stay/rooms'),
          ),
          _StayKpiData(
            title: "Today's Bookings",
            value: '${a?.todayBookings ?? 0}',
            subtitle: 'Check-ins scheduled',
            icon: Icons.today_rounded,
            color: const Color(0xFF059669),
            badge: '+18.5%',
          ),
          _StayKpiData(
            title: 'Upcoming Bookings',
            value: '${a?.upcomingBookings ?? 0}',
            subtitle: 'Next 14 days reserved',
            icon: Icons.event_available_rounded,
            color: const Color(0xFF7C3AED),
            badge: 'Reserved',
          ),
          _StayKpiData(
            title: 'Total Revenue',
            value: Formatters.currency(a?.totalRevenue ?? 0),
            subtitle: 'Payout: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.secondary,
            badge: '+12.4%',
          ),
        ];

        if (isWide) {
          return Row(
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildCustomKpiCard(c),
                    ),
                  ),
                )
                .toList(),
          );
        }

        final crossCount = isMedium ? 3 : 2;
        final childAspectRatio = isMedium ? 1.45 : 1.35;

        return GridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          children: cards.map((c) => _buildCustomKpiCard(c)).toList(),
        );
      },
    );
  }

  /// Custom KPI Card carefully fitted for mobile viewports
  Widget _buildCustomKpiCard(_StayKpiData data) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: data.color.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(data.icon, color: data.color, size: 18),
                  ),
                  if (data.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: data.color.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data.badge!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: data.color,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: data.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Occupancy Health Highlight & Approval Card
  Widget _buildOccupancyHealthCard(StayDashboardAnalytics? a) {
    final occupancy = a?.occupancyRate ?? 0;
    final pending = a?.pendingApproval ?? 0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.insights_rounded,
                    color: AppColors.stayService,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Occupancy Rate & Health',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.stayService.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${occupancy.toStringAsFixed(1)}% Optimal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.stayService,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppProgressBar(
            percentage: occupancy,
            progressColor: AppColors.stayService,
            height: 8,
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    pending > 0
                        ? Icons.pending_actions_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 16,
                    color: pending > 0 ? AppColors.warning : AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Listing Approvals:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                pending > 0
                    ? '$pending Property in Review'
                    : 'All Properties Approved',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: pending > 0 ? AppColors.warning : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Responsive Charts Section (Monthly Revenue & Booking Status)
  Widget _buildAnalyticsChartsSection(StayDashboardAnalytics? a) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
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
                    height: 240,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                flex: 4,
                child: AppCard(
                  title: 'Booking Status Breakdown',
                  subtitle: 'Status distribution for stay bookings',
                  child: AppDonutChart(
                    slices: a?.bookingStatusBreakdown ?? [],
                    centerLabel: 'Bookings',
                    centerValue: '${a?.totalBookings ?? 0}',
                    height: 240,
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
                  height: 220,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              AppCard(
                title: 'Booking Status Breakdown',
                subtitle: 'Status distribution for stay bookings',
                child: AppDonutChart(
                  slices: a?.bookingStatusBreakdown ?? [],
                  centerLabel: 'Bookings',
                  centerValue: '${a?.totalBookings ?? 0}',
                  height: 220,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  /// Recent Reservations Mobile-Optimized List & Table
  Widget _buildRecentReservationsCard(List<StayBookingItemModel> bookings) {
    return AppCard(
      title: 'Recent Stay Reservations',
      subtitle: 'Latest guest check-ins & reservation requests',
      trailing: TextButton(
        onPressed: () => Get.toNamed('/bookings'),
        child: const Text('View All Bookings'),
      ),
      child: bookings.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No recent stay reservations found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                final b = bookings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.stayService.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            b.guestName.isNotEmpty
                                ? b.guestName[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.stayService,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.guestName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${b.propertyName} • ${b.roomType}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${b.checkIn} → ${b.checkOut} (${b.nights}N)',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.currency(b.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AppStatusChip(status: b.status.name),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  /// Property Performance & Recent Reviews Grid/Column
  Widget _buildPerformanceAndReviewsSection(StayDashboardAnalytics? a) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildPropertyPerformanceCard(
                  a?.propertyPerformances ?? [],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
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
              const SizedBox(height: AppDimensions.spaceMd),
              _buildRecentReviewsCard(a?.recentReviews ?? []),
            ],
          );
        }
      },
    );
  }

  Widget _buildPropertyPerformanceCard(
    List<PropertyPerformanceModel> performances,
  ) {
    return AppCard(
      title: 'Property Performance',
      subtitle: 'Occupancy & monthly revenue per property',
      child: performances.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No property performance data'),
            )
          : ListView.separated(
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPending
                            ? AppColors.warningLight
                            : AppColors.stayServiceBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isPending
                            ? Icons.hourglass_top_rounded
                            : Icons.apartment_rounded,
                        color: isPending
                            ? AppColors.warning
                            : AppColors.stayService,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
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
                            const SizedBox(height: 6),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.stayService,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isPending
                                ? AppColors.warningLight
                                : AppColors.successLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isPending
                                ? 'Under Review'
                                : '${p.occupancyPercentage.toInt()}% Occ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isPending
                                  ? AppColors.warning
                                  : AppColors.success,
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
      subtitle: 'Guest ratings & feedback',
      child: reviews.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No reviews yet'),
            )
          : ListView.separated(
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
                        Text(
                          r.guestName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber,
                            ),
                            Text(
                              ' ${r.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${r.propertyName} • ${r.date}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${r.comment}"',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _QuickActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;

  const _QuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

class _StayKpiData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback? onTap;

  const _StayKpiData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.badge,
    this.onTap,
  });
}
