import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/dashboard_metrics_model.dart';

abstract class DashboardDataSource {
  Future<ApiResponse<VendorCoreDashboardModel>> getCoreDashboardData({
    required List<ServiceType> assignedServices,
  });
}
