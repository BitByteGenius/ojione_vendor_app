import '../../../shared/enums/service_type.dart';
import '../models/vendor_home_data_model.dart';
import 'mock_vendor_home_datasource.dart';
import 'vendor_home_datasource.dart';

class VendorHomeRepository {
  final VendorHomeDataSource dataSource;

  VendorHomeRepository({VendorHomeDataSource? dataSource})
      : dataSource = dataSource ?? MockVendorHomeDataSource();

  Future<VendorHomeSummary> getHomeSummary({required List<ServiceType> assignedServices}) {
    return dataSource.getHomeSummary(assignedServices: assignedServices);
  }

  Future<List<VendorActivityItem>> getRecentActivities({required List<ServiceType> assignedServices}) {
    return dataSource.getRecentActivities(assignedServices: assignedServices);
  }

  Future<List<ServiceQuickStat>> getServiceQuickStats(ServiceType service) {
    return dataSource.getServiceQuickStats(service);
  }
}
