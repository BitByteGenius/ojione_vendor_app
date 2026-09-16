import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';

class PropertyPerformanceModel {
  final String id;
  final String name;
  final String propertyType;
  final int totalRooms;
  final double occupancyPercentage;
  final double monthRevenue;
  final double rating;
  final int reviewsCount;
  final String approvalStatus;

  const PropertyPerformanceModel({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.totalRooms,
    required this.occupancyPercentage,
    required this.monthRevenue,
    required this.rating,
    required this.reviewsCount,
    required this.approvalStatus,
  });
}

class StayBookingItemModel {
  final String id;
  final String guestName;
  final String propertyName;
  final String roomType;
  final String checkIn;
  final String checkOut;
  final int nights;
  final double amount;
  final BookingStatus status;

  const StayBookingItemModel({
    required this.id,
    required this.guestName,
    required this.propertyName,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.amount,
    required this.status,
  });
}

class StayReviewModel {
  final String guestName;
  final String propertyName;
  final double rating;
  final String comment;
  final String date;

  const StayReviewModel({
    required this.guestName,
    required this.propertyName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class StayDashboardAnalytics {
  final int totalProperties;
  final int activeProperties;
  final int pendingApproval;
  final int totalRooms;
  final int totalBookings;
  final int todayBookings;
  final int upcomingBookings;
  final double occupancyRate; // percentage e.g. 78.5
  final double totalRevenue;
  final double pendingPayouts;
  final List<ChartDataPoint> revenueOverview;
  final List<BarGroupDataModel> bookingTrends;
  final List<PieSliceDataModel> bookingStatusBreakdown;
  final List<PropertyPerformanceModel> propertyPerformances;
  final List<StayBookingItemModel> recentBookings;
  final List<StayReviewModel> recentReviews;

  const StayDashboardAnalytics({
    required this.totalProperties,
    required this.activeProperties,
    required this.pendingApproval,
    required this.totalRooms,
    required this.totalBookings,
    required this.todayBookings,
    required this.upcomingBookings,
    required this.occupancyRate,
    required this.totalRevenue,
    required this.pendingPayouts,
    required this.revenueOverview,
    required this.bookingTrends,
    required this.bookingStatusBreakdown,
    required this.propertyPerformances,
    required this.recentBookings,
    required this.recentReviews,
  });
}
