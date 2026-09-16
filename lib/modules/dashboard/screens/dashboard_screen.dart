import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/charts/app_kpi_card.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_metrics_model.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.to;

    return MainLayout(
      title: 'Vendor Core Dashboard',
      body: Obx(() {
        if (controller.isLoading.value && controller.dashboardData.value == null) {
          return const AppLoader(message: 'Loading vendor account overview...');
        }

        final data = controller.dashboardData.value;
        final assigned = auth.assignedServices.toList();

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor Profile & Verification Status Banner
                _buildVendorIdentityBanner(context, auth),
                const SizedBox(height: AppDimensions.spaceLg),

                // High-Level Aggregate KPI Row (Only across registered services)
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
                      childAspectRatio: isWide ? 1.7 : (isMedium ? 1.9 : 2.4),
                      children: [
                        AppKpiCard(
                          title: 'Overall Platform Earnings',
                          value: Formatters.currency(data?.totalEarnings ?? 0),
                          subtitle: 'Aggregated for active services',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.primary,
                          trendBadge: '+14.2%',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Pending Payout Settlement',
                          value: Formatters.currency(data?.pendingPayout ?? 0),
                          subtitle: 'Next bank transfer: Friday',
                          icon: Icons.payments_outlined,
                          color: AppColors.secondary,
                          trendBadge: 'Scheduled',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Total Platform Bookings',
                          value: '${data?.totalBookingsCount ?? 0}',
                          subtitle: 'Across registered services',
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFF2563EB),
                          trendBadge: '+9.8%',
                          isPositiveTrend: true,
                        ),
                        AppKpiCard(
                          title: 'Active Service Portals',
                          value: '${assigned.length} of 5',
                          subtitle: 'Independent service modules',
                          icon: Icons.layers_rounded,
                          color: const Color(0xFF7C3AED),
                          trendBadge: 'Isolated',
                          isPositiveTrend: true,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceXl),

                // Assigned Services Hub (Strict separation gateway)
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
                          'Each service has its own dedicated dashboard with deep analytics, listings, and bookings.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed('/register'),
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                      label: const Text('Add Service'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceSm),

                // Service Isolation Notice Alert
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd,
                    vertical: AppDimensions.spaceSm + 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Strict Service Separation Active: You only have access to the service(s) you registered. Detailed analytics, booking charts, and inventory are managed inside each separate service dashboard.',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Dynamic Service Cards Grid
                if (data != null && data.serviceSummaries.isNotEmpty)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 800;
                      return GridView.builder(
                        itemCount: data.serviceSummaries.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 2 : 1,
                          crossAxisSpacing: AppDimensions.spaceMd,
                          mainAxisSpacing: AppDimensions.spaceMd,
                          mainAxisExtent: 180,
                        ),
                        itemBuilder: (context, index) {
                          final s = data.serviceSummaries[index];
                          return _buildServicePortalCard(context, s);
                        },
                      );
                    },
                  )
                else
                  const AppCard(
                    title: 'No Services Assigned',
                    child: Text('No service portals are currently active for this vendor.'),
                  ),

                const SizedBox(height: AppDimensions.spaceXl),

                // Bottom Section: Recent Account Activity & Profile Summary
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildRecentActivityCard(data?.recentActivities ?? []),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: _buildAccountComplianceCard(auth),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildRecentActivityCard(data?.recentActivities ?? []),
                          const SizedBox(height: AppDimensions.spaceLg),
                          _buildAccountComplianceCard(auth),
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

  Widget _buildVendorIdentityBanner(BuildContext context, AuthService auth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF0D7A57), const Color(0xFF064E3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withAlpha(40),
                child: Text(
                  auth.ownerName.value.isNotEmpty
                      ? auth.ownerName.value.substring(0, 1).toUpperCase()
                      : 'V',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            auth.vendorName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: auth.verificationStatus.value.bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            auth.verificationStatus.value.label,
                            style: TextStyle(
                              color: auth.verificationStatus.value.color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Owner: ${auth.ownerName.value}  •  Vendor ID: ${auth.vendorId.value}  •  ${auth.city.value}, ${auth.state.value}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(210),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: AppDimensions.spaceSm),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _bannerBadge(Icons.badge_outlined, 'Aadhaar: ${auth.aadhaarNumber.value}'),
              _bannerBadge(Icons.phone_outlined, auth.phone.value),
              _bannerBadge(Icons.mail_outline_rounded, auth.email.value),
              _bannerBadge(Icons.domain_verification_rounded, 'Account: ${auth.accountStatus.value.label}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFFD1FAE5)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: Color(0xFFD1FAE5), fontSize: 11.5, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildServicePortalCard(BuildContext context, ServicePortalSummary summary) {
    final srv = summary.service;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: srv.color.withAlpha(isDark ? 80 : 50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: srv.color.withAlpha(isDark ? 20 : 10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: srv.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(srv.icon, color: srv.color, size: 24),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      srv.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      srv.description,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Listings', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    '${summary.activeListingsCount}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today Bookings', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    '${summary.todayBookingsCount}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Month Revenue', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    Formatters.currency(summary.monthRevenue),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: srv.color),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                AuthService.to.setActiveService(srv);
                Get.toNamed(srv.routePath);
              },
              icon: Icon(srv.icon, size: 16),
              label: Text('Open ${srv.displayName} Dashboard →'),
              style: ElevatedButton.styleFrom(
                backgroundColor: srv.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(List<VendorActivityItem> activities) {
    return AppCard(
      title: 'Recent Vendor Activity & Audits',
      subtitle: 'Account, compliance, and cross-service milestones',
      child: activities.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No recent activity recorded.'),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, _) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final item = activities[index];
                IconData icon;
                Color color;

                if (item.type == 'kyc') {
                  icon = Icons.verified_user_rounded;
                  color = AppColors.success;
                } else if (item.type == 'payout') {
                  icon = Icons.account_balance_rounded;
                  color = AppColors.secondary;
                } else {
                  icon = item.serviceType?.icon ?? Icons.notifications_rounded;
                  color = item.serviceType?.color ?? AppColors.primary;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(item.description, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item.timestamp, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildAccountComplianceCard(AuthService auth) {
    return AppCard(
      title: 'Business Identity & Compliance',
      subtitle: 'Registered government and banking credentials',
      trailing: TextButton(
        onPressed: () => Get.toNamed('/profile'),
        child: const Text('Manage'),
      ),
      child: Column(
        children: [
          _complianceItem(
            'Aadhaar Verification',
            auth.aadhaarNumber.value,
            'Verified via UIDAI',
            Icons.fingerprint_rounded,
            AppColors.success,
          ),
          const Divider(height: 16),
          _complianceItem(
            'Bank Settlement Account',
            'HDFC Bank •••• 9842',
            'Active for auto-payouts',
            Icons.account_balance_rounded,
            AppColors.primary,
          ),
          const Divider(height: 16),
          _complianceItem(
            'Commercial Address',
            '${auth.city.value}, ${auth.state.value} - ${auth.pincode.value}',
            auth.address.value,
            Icons.location_on_outlined,
            const Color(0xFF0284C7),
          ),
          const Divider(height: 16),
          _complianceItem(
            'Vendor Support Desk',
            'support@sewasetu.gov.in',
            'Toll Free: 1800-2026-SETU',
            Icons.support_agent_rounded,
            const Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }

  Widget _complianceItem(String label, String value, String sub, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(sub, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
