import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/trips_repository.dart';
import '../models/trip_package_model.dart';

class TripsController extends GetxController {
  final TripsRepository _repository = TripsRepository();

  final isLoading = true.obs;
  final packages = <TripPackageModel>[].obs;
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
    loadPackages();
  }

  Future<void> loadPackages() async {
    try {
      isLoading.value = true;
      final res = await _repository.getPackages();
      if (res.success && res.data != null) {
        packages.assignAll(res.data!);
        if (packages.isNotEmpty && selectedPackage.value == null) {
          selectedPackage.value = packages.first;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tour packages');
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
        loadPackages();
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
