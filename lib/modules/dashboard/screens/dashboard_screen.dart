import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/metric_card.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/service_overview_card.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return MainLayout(
      title: 'Vendor Overview',
      body: Obx(() {
        if (controller.isLoading.value && controller.metrics.value == null) {
          return const AppLoader(message: 'Loading dashboard insights...');
        }

        final m = controller.metrics.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome & Active Services Badge Header
              _buildWelcomeBanner(context, auth),
              const SizedBox(height: AppDimensions.spaceLg),

              // Quick Actions Bar
              const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppDimensions.spaceSm),
              const QuickActionsBar(),
              const SizedBox(height: AppDimensions.spaceLg),

              // Metric Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final isMedium = constraints.maxWidth > 600;
                  final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppDimensions.spaceMd,
                    mainAxisSpacing: AppDimensions.spaceMd,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isWide ? 1.6 : (isMedium ? 1.8 : 2.2),
                    children: [
                      MetricCard(
                        title: 'Total Earnings',
                        value: Formatters.currency(m?.totalEarnings ?? 0),
                        subtitle: 'vs last month',
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppColors.primary,
                        badgeText: '+14.5%',
                      ),
                      MetricCard(
                        title: 'Total Bookings',
                        value: '${m?.totalBookings ?? 0}',
                        subtitle: 'Across all services',
                        icon: Icons.calendar_month_rounded,
                        color: AppColors.stayService,
                        badgeText: '+8.2%',
                      ),
                      MetricCard(
                        title: 'Active Listings',
                        value: '${m?.activeListings ?? 0}',
                        subtitle: 'Live in marketplace',
                        icon: Icons.storefront_rounded,
                        color: AppColors.secondary,
                        badgeText: 'Live',
                      ),
                      MetricCard(
                        title: 'Pending Approvals',
                        value: '${m?.pendingApprovals ?? 0}',
                        subtitle: 'Awaiting admin review',
                        icon: Icons.hourglass_top_rounded,
                        color: AppColors.warning,
                        badgeText: 'Review',
                        isPositiveBadge: false,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Dynamic Services Section (Shows only enabled services for this vendor)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Assigned Marketplace Services',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Dynamic modules enabled for your vendor account',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed('/profile'),
                    icon: const Icon(Icons.tune_rounded, size: 16),
                    label: const Text('Manage Services'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Service Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 800;
                  return GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 2 : 1,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      mainAxisExtent: 140,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (auth.hasService(ServiceType.stay))
                        const ServiceOverviewCard(
                          service: ServiceType.stay,
                          activeCount: 8,
                          pendingOrders: 14,
                          revenue: 185000,
                        ),
                      if (auth.hasService(ServiceType.trips))
                        const ServiceOverviewCard(
                          service: ServiceType.trips,
                          activeCount: 4,
                          pendingOrders: 6,
                          revenue: 92000,
                        ),
                      if (auth.hasService(ServiceType.shop))
                        const ServiceOverviewCard(
                          service: ServiceType.shop,
                          activeCount: 32,
                          pendingOrders: 28,
                          revenue: 48500,
                        ),
                      if (auth.hasService(ServiceType.rental))
                        const ServiceOverviewCard(
                          service: ServiceType.rental,
                          activeCount: 5,
                          pendingOrders: 9,
                          revenue: 34000,
                        ),
                      if (auth.hasService(ServiceType.localExperiences))
                        const ServiceOverviewCard(
                          service: ServiceType.localExperiences,
                          activeCount: 3,
                          pendingOrders: 12,
                          revenue: 25000,
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Recent Cross-Service Bookings Table
              AppCard(
                title: 'Recent Marketplace Bookings',
                subtitle: 'Unified view across Stay, Trips, Rental, & Local Experiences',
                trailing: TextButton(
                  onPressed: () => Get.toNamed('/bookings'),
                  child: const Text('View All Bookings'),
                ),
                child: _buildRecentBookingsTable(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, AuthService auth) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${auth.ownerName.value}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Managing: ${auth.vendorName.value} • Role: ${auth.currentRole.value.label}',
                  style: const TextStyle(
                    color: Color(0xFFD1FAE5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsTable() {
    final recentBookings = [
      {'id': 'BK-1049', 'customer': 'Rohan Das', 'service': 'Stay (Boutique Villa)', 'date': 'Today, 2:30 PM', 'amount': '₹8,500', 'status': 'confirmed'},
      {'id': 'BK-1048', 'customer': 'Priya Sen', 'service': 'Local Experience (Assam Tea Workshop)', 'date': 'Today, 11:15 AM', 'amount': '₹2,400', 'status': 'confirmed'},
      {'id': 'BK-1047', 'customer': 'Amit Baruah', 'service': 'Vehicle Rental (SUV 7-Seater)', 'date': 'Yesterday', 'amount': '₹5,600', 'status': 'completed'},
      {'id': 'BK-1046', 'customer': 'Neha Verma', 'service': 'Trips (Kaziranga Wildlife Safari)', 'date': '14 Sep 2026', 'amount': '₹18,000', 'status': 'pending'},
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(2.5),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(1.2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.lightBorder, width: 1)),
          ),
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('BOOKING ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('SERVICE & ITEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('BOOKING DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          ],
        ),
        ...recentBookings.map((b) => TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.lightBorder, width: 0.5)),
              ),
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(b['id']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(b['customer']!)),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(b['service']!)),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(b['date']!)),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(b['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: AppStatusChip(status: b['status']!)),
              ],
            )),
      ],
    );
  }
}
