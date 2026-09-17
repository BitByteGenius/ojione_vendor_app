import '../../../shared/enums/service_type.dart';
import '../models/vendor_home_data_model.dart';

abstract class VendorHomeDataSource {
  Future<VendorHomeSummary> getHomeSummary({required List<ServiceType> assignedServices});
  Future<List<VendorActivityItem>> getRecentActivities({required List<ServiceType> assignedServices});
  Future<List<ServiceQuickStat>> getServiceQuickStats(ServiceType service);
}
