import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/dashboard_metrics_model.dart';
import 'dashboard_data_source.dart';

class MockDashboardDataSource implements DashboardDataSource {
  @override
  Future<ApiResponse<VendorCoreDashboardModel>> getCoreDashboardData({
    required List<ServiceType> assignedServices,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Base statistics per service
    final serviceStatsMap = <ServiceType, ServicePortalSummary>{
      ServiceType.stay: const ServicePortalSummary(
        service: ServiceType.stay,
        activeListingsCount: 8,
        todayBookingsCount: 5,
        monthRevenue: 184500,
        status: 'Operational',
      ),
      ServiceType.trips: const ServicePortalSummary(
        service: ServiceType.trips,
        activeListingsCount: 6,
        todayBookingsCount: 3,
        monthRevenue: 112000,
        status: 'Operational',
      ),
      ServiceType.shop: const ServicePortalSummary(
        service: ServiceType.shop,
        activeListingsCount: 34,
        todayBookingsCount: 14,
        monthRevenue: 64200,
        status: 'Operational',
      ),
      ServiceType.rental: const ServicePortalSummary(
        service: ServiceType.rental,
        activeListingsCount: 10,
        todayBookingsCount: 4,
        monthRevenue: 48900,
        status: 'Operational',
      ),
      ServiceType.localExperiences: const ServicePortalSummary(
        service: ServiceType.localExperiences,
        activeListingsCount: 5,
        todayBookingsCount: 2,
        monthRevenue: 31500,
        status: 'Operational',
      ),
    };

    // Filter summaries strictly for assigned services
    final summaries = assignedServices
        .where((s) => serviceStatsMap.containsKey(s))
        .map((s) => serviceStatsMap[s]!)
        .toList();

    double totalEarnings = 0;
    int totalBookings = 0;
    int activeListings = 0;

    for (final s in summaries) {
      totalEarnings += s.monthRevenue;
      totalBookings += s.todayBookingsCount * 12; // aggregate monthly estimate
      activeListings += s.activeListingsCount;
    }

    final allActivities = [
      const VendorActivityItem(
        id: 'act-1',
        title: 'GST & Aadhaar KYC Verified',
        description: 'Vendor account status updated to Verified by SewaSetu Compliance Team.',
        timestamp: 'Today, 10:45 AM',
        type: 'kyc',
      ),
      const VendorActivityItem(
        id: 'act-2',
        title: 'Payout Dispatched',
        description: 'Monthly settlement of ₹45,000 initiated to registered HDFC Bank account.',
        timestamp: 'Yesterday, 4:15 PM',
        type: 'payout',
      ),
      const VendorActivityItem(
        id: 'act-3',
        title: 'Stay Booking Confirmed',
        description: 'Booking #BK-8821 for 3 nights in Deluxe Heritage Cottage.',
        timestamp: 'Yesterday, 11:30 AM',
        serviceType: ServiceType.stay,
        type: 'booking',
      ),
      const VendorActivityItem(
        id: 'act-4',
        title: 'Rental Booking Received',
        description: 'Booking #BK-7704 for SUV self-drive 4 days rental.',
        timestamp: '2 days ago',
        serviceType: ServiceType.rental,
        type: 'booking',
      ),
      const VendorActivityItem(
        id: 'act-5',
        title: 'Shop Order Placed',
        description: 'Order #ORD-5502 for Muga Silk Saree dispatch pending.',
        timestamp: '2 days ago',
        serviceType: ServiceType.shop,
        type: 'booking',
      ),
      const VendorActivityItem(
        id: 'act-6',
        title: 'Trip Package Reserved',
        description: 'Kaziranga Safari package booked for 4 passengers.',
        timestamp: '3 days ago',
        serviceType: ServiceType.trips,
        type: 'booking',
      ),
      const VendorActivityItem(
        id: 'act-7',
        title: 'Experience Registration',
        description: '3 slots reserved for Traditional Tea Tasting & Garden Tour.',
        timestamp: '4 days ago',
        serviceType: ServiceType.localExperiences,
        type: 'booking',
      ),
    ];

    // Filter activities: include platform-level ('kyc', 'payout') or assigned service activities
    final filteredActivities = allActivities.where((a) {
      if (a.serviceType == null) return true;
      return assignedServices.contains(a.serviceType);
    }).toList();

    final model = VendorCoreDashboardModel(
      totalEarnings: totalEarnings,
      pendingPayout: totalEarnings * 0.18,
      totalBookingsCount: totalBookings,
      activeListingsCount: activeListings,
      serviceSummaries: summaries,
      recentActivities: filteredActivities,
    );

    return ApiResponse.success(data: model);
  }
}
