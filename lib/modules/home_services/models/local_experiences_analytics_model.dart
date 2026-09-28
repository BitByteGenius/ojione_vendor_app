import '../../../shared/enums/booking_status.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';

class ExperiencePerformanceModel {
  final String id;
  final String title;
  final String category;
  final int participantsCount;
  final double revenue;
  final double rating;
  final int reviewsCount;
  final String status;

  const ExperiencePerformanceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.participantsCount,
    required this.revenue,
    required this.rating,
    required this.reviewsCount,
    required this.status,
  });
}

class ExperienceBookingItemModel {
  final String id;
  final String participantName;
  final String experienceTitle;
  final String slotDate;
  final String slotTime;
  final int participantsCount;
  final double amount;
  final BookingStatus status;

  const ExperienceBookingItemModel({
    required this.id,
    required this.participantName,
    required this.experienceTitle,
    required this.slotDate,
    required this.slotTime,
    required this.participantsCount,
    required this.amount,
    required this.status,
  });
}

class LocalExperiencesDashboardAnalytics {
  final int totalExperiences;
  final int activeExperiences;
  final int pendingApproval;
  final int totalBookings;
  final int upcomingExperiences;
  final int totalParticipants;
  final double totalRevenue;
  final double pendingPayouts;
  final List<ChartDataPoint> revenueTrends;
  final List<BarGroupDataModel> bookingTrends;
  final List<ExperiencePerformanceModel> experiencePerformances;
  final List<PieSliceDataModel> bookingStatusBreakdown;
  final List<ExperienceBookingItemModel> recentBookings;

  const LocalExperiencesDashboardAnalytics({
    required this.totalExperiences,
    required this.activeExperiences,
    required this.pendingApproval,
    required this.totalBookings,
    required this.upcomingExperiences,
    required this.totalParticipants,
    required this.totalRevenue,
    required this.pendingPayouts,
    required this.revenueTrends,
    required this.bookingTrends,
    required this.experiencePerformances,
    required this.bookingStatusBreakdown,
    required this.recentBookings,
  });
}
