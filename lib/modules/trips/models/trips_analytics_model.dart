import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';

class PackagePerformanceModel {
  final String id;
  final String title;
  final String duration;
  final int totalBookings;
  final double revenue;
  final double rating;
  final int reviewsCount;
  final String status;

  const PackagePerformanceModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.totalBookings,
    required this.revenue,
    required this.rating,
    required this.reviewsCount,
    required this.status,
  });
}

class TripBookingItemModel {
  final String id;
  final String customerName;
  final String packageTitle;
  final String departureDate;
  final int travelersCount;
  final double amount;
  final BookingStatus status;

  const TripBookingItemModel({
    required this.id,
    required this.customerName,
    required this.packageTitle,
    required this.departureDate,
    required this.travelersCount,
    required this.amount,
    required this.status,
  });
}

class TripsDashboardAnalytics {
  final int totalPackages;
  final int activePackages;
  final int pendingApproval;
  final int totalBookings;
  final int upcomingTrips;
  final int totalCustomers;
  final double totalRevenue;
  final double pendingPayouts;
  final List<ChartDataPoint> revenueTrends;
  final List<BarGroupDataModel> bookingTrends;
  final List<PackagePerformanceModel> packagePerformances;
  final List<PieSliceDataModel> bookingStatusBreakdown;
  final List<TripBookingItemModel> recentBookings;

  const TripsDashboardAnalytics({
    required this.totalPackages,
    required this.activePackages,
    required this.pendingApproval,
    required this.totalBookings,
    required this.upcomingTrips,
    required this.totalCustomers,
    required this.totalRevenue,
    required this.pendingPayouts,
    required this.revenueTrends,
    required this.bookingTrends,
    required this.packagePerformances,
    required this.bookingStatusBreakdown,
    required this.recentBookings,
  });
}
