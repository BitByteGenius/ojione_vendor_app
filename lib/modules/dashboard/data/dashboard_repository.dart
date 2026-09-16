import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/dashboard_metrics_model.dart';
import 'dashboard_data_source.dart';
import 'mock_dashboard_data_source.dart';

class DashboardRepository {
  final DashboardDataSource _dataSource;

  DashboardRepository({DashboardDataSource? dataSource})
      : _dataSource = dataSource ?? MockDashboardDataSource();

  Future<ApiResponse<VendorCoreDashboardModel>> getCoreDashboardData({
    required List<ServiceType> assignedServices,
  }) {
    return _dataSource.getCoreDashboardData(assignedServices: assignedServices);
  }
}
