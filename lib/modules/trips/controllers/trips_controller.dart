import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/trips_repository.dart';
import '../models/trip_package_model.dart';
import '../models/trips_analytics_model.dart';

class TripsController extends GetxController {
  final TripsRepository _repository = TripsRepository();

  final isLoading = true.obs;
  final packages = <TripPackageModel>[].obs;
  final analytics = Rx<TripsDashboardAnalytics?>(null);
  final selectedPackage = Rxn<TripPackageModel>();

  // Add Package Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final daysController = TextEditingController(text: '3');
  final nightsController = TextEditingController(text: '2');
  final priceController = TextEditingController();
  final destinationsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final analyticsFuture = _repository.getTripsAnalytics();
      final packagesFuture = _repository.getPackages();

      final results = await Future.wait([analyticsFuture, packagesFuture]);
      final analyticsRes = results[0] as dynamic;
      final packagesRes = results[1] as dynamic;

      if (analyticsRes.success && analyticsRes.data != null) {
        analytics.value = analyticsRes.data;
      }
      if (packagesRes.success && packagesRes.data != null) {
        packages.assignAll(packagesRes.data!);
        if (packages.isNotEmpty && selectedPackage.value == null) {
          selectedPackage.value = packages.first;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tour packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPackage() async {
    if (titleController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Validation', 'Please fill in package title and price');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.createPackage({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'duration_days': int.tryParse(daysController.text) ?? 3,
        'duration_nights': int.tryParse(nightsController.text) ?? 2,
        'price_per_person': double.tryParse(priceController.text) ?? 9999,
        'destinations': destinationsController.text.split(',').map((e) => e.trim()).toList(),
      });
      if (res.success) {
        Get.snackbar('Success', 'Trip package submitted for approval');
        loadDashboardData();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit trip package');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    daysController.dispose();
    nightsController.dispose();
    priceController.dispose();
    destinationsController.dispose();
    super.onClose();
  }
}
