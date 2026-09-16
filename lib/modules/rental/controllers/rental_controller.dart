import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/rental_repository.dart';
import '../models/rental_analytics_model.dart';
import '../models/vehicle_model.dart';

class RentalController extends GetxController {
  final RentalRepository _repository = RentalRepository();

  final isLoading = true.obs;
  final vehicles = <VehicleModel>[].obs;
  final cities = <String>[].obs;
  final analytics = Rx<RentalDashboardAnalytics?>(null);
  final selectedCityFilter = 'All Cities'.obs;

  // Add Vehicle Form Controllers
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final regNumberController = TextEditingController();
  final pricePerDayController = TextEditingController();
  final selectedCity = 'Guwahati'.obs;
  final selectedCategory = 'SUV 7-Seater'.obs;
  final selectedRentalType = 'Both'.obs;

  @override
  void onInit() {
    super.onInit();
    loadRentalData();
  }

  Future<void> loadRentalData() async {
    try {
      isLoading.value = true;
      final aFuture = _repository.getRentalAnalytics();
      final cFuture = _repository.getAvailableCities();
      final vFuture = _repository.getVehicles();

      final results = await Future.wait([aFuture, cFuture, vFuture]);
      final aRes = results[0] as dynamic;
      final cRes = results[1] as dynamic;
      final vRes = results[2] as dynamic;

      if (aRes.success && aRes.data != null) {
        analytics.value = aRes.data;
      }
      if (cRes.success && cRes.data != null) {
        cities.assignAll(cRes.data!);
        if (cities.isNotEmpty) selectedCity.value = cities.first;
      }
      if (vRes.success && vRes.data != null) {
        vehicles.assignAll(vRes.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load rental fleet: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<VehicleModel> get filteredVehicles {
    if (selectedCityFilter.value == 'All Cities') return vehicles;
    return vehicles.where((v) => v.operatingCity == selectedCityFilter.value).toList();
  }

  Future<void> submitVehicle() async {
    if (makeController.text.isEmpty || modelController.text.isEmpty || regNumberController.text.isEmpty) {
      Get.snackbar('Validation', 'Make, model, and registration number are required');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.createVehicle({
        'make': makeController.text.trim(),
        'model_name': modelController.text.trim(),
        'registration_number': regNumberController.text.trim().toUpperCase(),
        'operating_city': selectedCity.value,
        'category': selectedCategory.value,
        'rental_type': selectedRentalType.value,
        'price_per_day': double.tryParse(pricePerDayController.text) ?? 2500,
      });
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadRentalData();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add vehicle');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    makeController.dispose();
    modelController.dispose();
    regNumberController.dispose();
    pricePerDayController.dispose();
    super.onClose();
  }
}
