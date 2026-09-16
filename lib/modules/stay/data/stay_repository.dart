import '../../../core/network/api_response.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_model.dart';
import '../models/stay_analytics_model.dart';
import 'mock_stay_data_source.dart';
import 'stay_data_source.dart';

class StayRepository {
  final StayDataSource _dataSource;

  StayRepository({StayDataSource? dataSource})
      : _dataSource = dataSource ?? MockStayDataSource();

  Future<ApiResponse<StayDashboardAnalytics>> getStayAnalytics() {
    return _dataSource.getStayAnalytics();
  }

  Future<ApiResponse<List<PropertyModel>>> getProperties() {
    return _dataSource.getProperties();
  }

  Future<ApiResponse<StayPricingModel>> getPricing(String propertyId) {
    return _dataSource.getPricing(propertyId);
  }

  Future<ApiResponse<List<StayAvailabilityModel>>> getAvailability(String propertyId) {
    return _dataSource.getAvailability(propertyId);
  }

  Future<ApiResponse<bool>> createProperty(Map<String, dynamic> data) {
    return _dataSource.createProperty(data);
  }
}
