import '../../../core/network/api_response.dart';
import '../models/rental_analytics_model.dart';
import '../models/vehicle_model.dart';
import 'mock_rental_data_source.dart';
import 'rental_data_source.dart';

class RentalRepository {
  final RentalDataSource _dataSource;

  RentalRepository({RentalDataSource? dataSource})
      : _dataSource = dataSource ?? MockRentalDataSource();

  Future<ApiResponse<RentalDashboardAnalytics>> getRentalAnalytics() {
    return _dataSource.getRentalAnalytics();
  }

  Future<ApiResponse<List<VehicleModel>>> getVehicles() {
    return _dataSource.getVehicles();
  }

  Future<ApiResponse<List<String>>> getAvailableCities() {
    return _dataSource.getAvailableCities();
  }

  Future<ApiResponse<bool>> createVehicle(Map<String, dynamic> data) {
    return _dataSource.createVehicle(data);
  }
}
