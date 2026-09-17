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
import '../controllers/local_experiences_controller.dart';
import '../models/local_experiences_analytics_model.dart';

class ExperiencesDashboardScreen extends GetView<LocalExperiencesController> {
  const ExperiencesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Local Experiences Vendor Portal',
      trailingHeader: AppButton(
        text: '+ Add Experience',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/experiences/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(message: 'Loading Local Experiences analytics...');
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
                          title: 'Total Experiences',
                          value: '${a?.totalExperiences ?? 0}',
                          subtitle: '${a?.activeExperiences ?? 0} Live • ${a?.pendingApproval ?? 0} Review',
                          icon: Icons.local_activity_rounded,
                          color: AppColors.localExpService,
                          trendBadge: 'Catalog',
                          onTap: () => Get.toNamed('/experiences/list'),
                        ),
                        AppKpiCard(
                          title: 'Total Participants',
                          value: '${a?.totalParticipants ?? 0} Guests',
                          subtitle: 'Joined workshops & walks',
                          icon: Icons.people_alt_rounded,
                          color: const Color(0xFF0284C7),
                          trendBadge: '+21.5%',
                        ),
                        AppKpiCard(
                          title: 'Upcoming Sessions',
                          value: '${a?.upcomingExperiences ?? 0}',
                          subtitle: 'Bookings: ${a?.totalBookings ?? 0}',
                          icon: Icons.calendar_month_rounded,
                          color: AppColors.primary,
                          trendBadge: 'Active',
                          onTap: () => Get.toNamed('/experiences/schedule'),
                        ),
                        AppKpiCard(
                          title: 'Experience Revenue',
                          value: Formatters.currency(a?.totalRevenue ?? 0),
                          subtitle: 'Pending payout: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                          trendBadge: '+15.4%',
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Dynamic Categories Showcase (Model-driven, backend-ready)
                const Text(
                  'Supported Experience Categories',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dynamic category configuration loaded from repository',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          avatar: const Icon(Icons.star_outline_rounded, size: 16, color: AppColors.localExpService),
                          label: Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.localExpService,
                            ),
                          ),
                          backgroundColor: AppColors.localExpServiceBg,
                          side: BorderSide(color: AppColors.localExpService.withAlpha(60)),
                        ),
                      );
                    }).toList(),
                  ),
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
                              title: 'Monthly Revenue Trends (Past 6 Months)',
                              subtitle: 'Gross ticket earnings from workshops and tours (INR)',
                              child: AppLineChart(
                                dataPoints: a?.revenueTrends ?? [],
                                primaryColor: AppColors.localExpService,
                                valueFormatter: (v) => Formatters.currency(v),
                                height: 260,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: AppCard(
                              title: 'Slot Booking Status',
                              subtitle: 'Guest reservation breakdown',
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
                            title: 'Monthly Revenue Trends (Past 6 Months)',
                            subtitle: 'Gross ticket earnings from workshops and tours (INR)',
                            child: AppLineChart(
                              dataPoints: a?.revenueTrends ?? [],
                              primaryColor: AppColors.localExpService,
                              valueFormatter: (v) => Formatters.currency(v),
                              height: 240,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                          AppCard(
                            title: 'Slot Booking Status',
                            subtitle: 'Guest reservation breakdown',
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

                // Daily Booking Volume Bar Chart
                AppCard(
                  title: 'Daily Participant Bookings (Past 7 Days)',
                  subtitle: 'Confirmed guest attendees reserved per day',
                  child: AppBarChart(
                    groups: a?.bookingTrends ?? [],
                    barColor: AppColors.localExpService,
                    height: 220,
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Recent Bookings Table
                AppCard(
                  title: 'Recent Participant Bookings',
                  subtitle: 'Confirmed guest reservations for upcoming workshops & walks',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/bookings'),
                    child: const Text('View All Bookings'),
                  ),
                  child: _buildRecentBookingsTable(a?.recentBookings ?? []),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Experience Performance List
                AppCard(
                  title: 'Experience Popularity & Revenue',
                  subtitle: 'Attendee counts and revenue generated per local experience',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/experiences/list'),
                    child: const Text('Manage Experiences'),
                  ),
                  child: _buildExperiencePerformanceList(a?.experiencePerformances ?? []),
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
            avatar: const Icon(Icons.local_activity_outlined, size: 16, color: AppColors.localExpService),
            label: const Text('Experiences Catalog'),
            onPressed: () => Get.toNamed('/experiences/list'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.schedule_outlined, size: 16, color: AppColors.localExpService),
            label: const Text('Schedules & Time Slots'),
            onPressed: () => Get.toNamed('/experiences/schedule'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsTable(List<ExperienceBookingItemModel> bookings) {
    if (bookings.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No experience bookings found.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('PARTICIPANT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('EXPERIENCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('SLOT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('GUESTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ],
        rows: bookings.map((b) {
          return DataRow(
            cells: [
              DataCell(Text(b.id, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(b.participantName)),
              DataCell(Text(b.experienceTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5))),
              DataCell(Text('${b.slotDate}, ${b.slotTime}', style: const TextStyle(fontSize: 12))),
              DataCell(Text('${b.participantsCount} Guests')),
              DataCell(Text(Formatters.currency(b.amount), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(AppStatusChip(status: b.status.name)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExperiencePerformanceList(List<ExperiencePerformanceModel> performances) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: performances.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final p = performances[index];

        return Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.localExpServiceBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_activity_rounded,
                color: AppColors.localExpService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${p.category} • ★ ${p.rating} (${p.reviewsCount} reviews) • ${p.participantsCount} Participants',
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
                  Formatters.currency(p.revenue),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.localExpService),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p.status,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
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
