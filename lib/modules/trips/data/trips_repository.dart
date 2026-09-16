import '../../../core/network/api_response.dart';
import '../models/trip_package_model.dart';
import '../models/trips_analytics_model.dart';
import 'mock_trips_data_source.dart';
import 'trips_data_source.dart';

class TripsRepository {
  final TripsDataSource _dataSource;

  TripsRepository({TripsDataSource? dataSource})
      : _dataSource = dataSource ?? MockTripsDataSource();

  Future<ApiResponse<TripsDashboardAnalytics>> getTripsAnalytics() {
    return _dataSource.getTripsAnalytics();
  }

  Future<ApiResponse<List<TripPackageModel>>> getPackages() {
    return _dataSource.getPackages();
  }

  Future<ApiResponse<bool>> createPackage(Map<String, dynamic> data) {
    return _dataSource.createPackage(data);
  }
}
