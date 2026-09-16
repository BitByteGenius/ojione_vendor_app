import '../../../core/network/api_response.dart';
import '../models/trip_package_model.dart';
import '../models/trips_analytics_model.dart';

abstract class TripsDataSource {
  Future<ApiResponse<TripsDashboardAnalytics>> getTripsAnalytics();
  Future<ApiResponse<List<TripPackageModel>>> getPackages();
  Future<ApiResponse<bool>> createPackage(Map<String, dynamic> data);
}
