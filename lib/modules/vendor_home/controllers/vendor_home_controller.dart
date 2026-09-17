import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';
import '../data/vendor_home_repository.dart';
import '../models/vendor_home_data_model.dart';

export '../models/vendor_home_data_model.dart';

class VendorHomeController extends GetxController {
  final VendorHomeRepository repository;
  final auth = AuthService.to;

  VendorHomeController({VendorHomeRepository? repository})
      : repository = repository ?? VendorHomeRepository();

  // Bottom navigation tab index
  final currentTabIndex = 0.obs;

  // Home summary data
  final summary = Rx<VendorHomeSummary?>(null);
  final isLoading = true.obs;
  final isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();

    // Dynamically reload summary and activities when vendor changes profile/assigned services
    ever(auth.assignedServices, (_) => loadHomeData());
  }

  Future<void> loadHomeData() async {
    try {
      final assigned = auth.assignedServices.toList();
      final data = await repository.getHomeSummary(assignedServices: assigned);
      summary.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHome() async {
    isRefreshing.value = true;
    try {
      await loadHomeData();
    } finally {
      isRefreshing.value = false;
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  double get settledBalance => summary.value?.settledBalance ?? 0.0;
  double get nextSettlement => summary.value?.nextSettlement ?? 0.0;
  String get settlementCycle => summary.value?.settlementCycle ?? 'Cycle: Friday';

  List<VendorActivityItem> get activities {
    return summary.value?.activities ?? [];
  }

  List<ServiceQuickStat> getServiceQuickStats(ServiceType service) {
    return summary.value?.serviceStats[service] ?? const [];
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void openServiceDashboard(ServiceType service) {
    auth.setActiveService(service);
    Get.toNamed(service.routePath);
  }
}
