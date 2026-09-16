import '../../../core/network/api_response.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_model.dart';
import '../models/stay_analytics_model.dart';

abstract class StayDataSource {
  Future<ApiResponse<StayDashboardAnalytics>> getStayAnalytics();
  Future<ApiResponse<List<PropertyModel>>> getProperties();
  Future<ApiResponse<StayPricingModel>> getPricing(String propertyId);
  Future<ApiResponse<List<StayAvailabilityModel>>> getAvailability(String propertyId);
  Future<ApiResponse<bool>> createProperty(Map<String, dynamic> data);
}
