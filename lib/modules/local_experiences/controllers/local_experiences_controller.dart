import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local_experiences_repository.dart';
import '../models/experience_model.dart';

class LocalExperiencesController extends GetxController {
  final LocalExperiencesRepository _repository = LocalExperiencesRepository();

  final isLoading = true.obs;
  final experiences = <ExperienceModel>[].obs;
  final selectedExperience = Rxn<ExperienceModel>();

  // Add Experience Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final cityController = TextEditingController(text: 'Guwahati');
  final meetingPointController = TextEditingController();
  final durationHoursController = TextEditingController(text: '2.5');
  final maxCapacityController = TextEditingController(text: '10');
  final priceController = TextEditingController();
  final selectedCategory = 'Cultural Walk'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExperiences();
  }

  Future<void> loadExperiences() async {
    try {
      isLoading.value = true;
      final res = await _repository.getExperiences();
      if (res.success && res.data != null) {
        experiences.assignAll(res.data!);
        if (experiences.isNotEmpty && selectedExperience.value == null) {
          selectedExperience.value = experiences.first;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load local experiences');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitExperience() async {
    if (titleController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Validation', 'Experience title and price are required');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.createExperience({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'city': cityController.text.trim(),
        'meeting_point': meetingPointController.text.trim(),
        'duration_hours': double.tryParse(durationHoursController.text) ?? 2.0,
        'max_capacity': int.tryParse(maxCapacityController.text) ?? 10,
        'price_per_person': double.tryParse(priceController.text) ?? 500,
      });
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadExperiences();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create experience');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    meetingPointController.dispose();
    durationHoursController.dispose();
    maxCapacityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
