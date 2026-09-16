import '../../../core/network/api_response.dart';
import '../models/rental_analytics_model.dart';
import '../models/vehicle_model.dart';

abstract class RentalDataSource {
  Future<ApiResponse<RentalDashboardAnalytics>> getRentalAnalytics();
  Future<ApiResponse<List<VehicleModel>>> getVehicles();
  Future<ApiResponse<List<String>>> getAvailableCities();
  Future<ApiResponse<bool>> createVehicle(Map<String, dynamic> data);
}
