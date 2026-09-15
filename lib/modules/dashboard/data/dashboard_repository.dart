import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../models/dashboard_metrics_model.dart';

class DashboardRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<DashboardMetricsModel>> getMetrics() async {
    // Backend API integration ready:
    // final response = await _apiClient.get(ApiEndpoints.dashboardMetrics);
    // return ApiResponse.fromJson(response.data, (json) => DashboardMetricsModel.fromJson(json));

    await Future.delayed(const Duration(milliseconds: 400));
    final mock = DashboardMetricsModel(
      totalEarnings: 384500,
      totalBookings: 148,
      activeListings: 19,
      pendingApprovals: 2,
      averageRating: 4.8,
      totalReviews: 96,
      monthlyRevenue: 124000,
      growthPercentage: 14.5,
    );
    return ApiResponse.success(data: mock);
  }
}
