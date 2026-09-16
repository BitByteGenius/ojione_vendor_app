import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_metrics_model.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  final isLoading = false.obs;
  final dashboardData = Rx<VendorCoreDashboardModel?>(null);
  final errorMessage = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadDashboard();

    // Listen to assigned services changes so switching profiles immediately re-fetches
    ever(AuthService.to.assignedServices, (_) {
      loadDashboard();
    });
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final res = await _repository.getCoreDashboardData(
        assignedServices: AuthService.to.assignedServices.toList(),
      );
      if (res.success && res.data != null) {
        dashboardData.value = res.data;
      } else {
        errorMessage.value = res.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    loadDashboard();
  }
}
