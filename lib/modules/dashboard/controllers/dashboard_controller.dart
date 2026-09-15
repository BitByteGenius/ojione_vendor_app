import 'package:get/get.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_metrics_model.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  final isLoading = true.obs;
  final metrics = Rxn<DashboardMetricsModel>();

  // Filter timeframe
  final selectedTimeframe = 'This Month'.obs;
  final List<String> timeframes = ['Today', 'This Week', 'This Month', 'This Year'];

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final response = await _repository.getMetrics();
      if (response.success && response.data != null) {
        metrics.value = response.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard metrics');
    } finally {
      isLoading.value = false;
    }
  }

  void setTimeframe(String tf) {
    selectedTimeframe.value = tf;
    loadDashboardData();
  }
}
