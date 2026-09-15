class DashboardMetricsModel {
  final double totalEarnings;
  final int totalBookings;
  final int activeListings;
  final int pendingApprovals;
  final double averageRating;
  final int totalReviews;
  final double monthlyRevenue;
  final double growthPercentage;

  DashboardMetricsModel({
    required this.totalEarnings,
    required this.totalBookings,
    required this.activeListings,
    required this.pendingApprovals,
    required this.averageRating,
    required this.totalReviews,
    required this.monthlyRevenue,
    required this.growthPercentage,
  });

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) {
    return DashboardMetricsModel(
      totalEarnings: (json['total_earnings'] ?? json['totalEarnings'] ?? 0).toDouble(),
      totalBookings: json['total_bookings'] ?? json['totalBookings'] ?? 0,
      activeListings: json['active_listings'] ?? json['activeListings'] ?? 0,
      pendingApprovals: json['pending_approvals'] ?? json['pendingApprovals'] ?? 0,
      averageRating: (json['average_rating'] ?? json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
      monthlyRevenue: (json['monthly_revenue'] ?? json['monthlyRevenue'] ?? 0).toDouble(),
      growthPercentage: (json['growth_percentage'] ?? json['growthPercentage'] ?? 0.0).toDouble(),
    );
  }
}
