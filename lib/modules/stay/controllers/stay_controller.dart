import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/stay_repository.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_model.dart';
import '../models/stay_analytics_model.dart';

class StayController extends GetxController {
  final StayRepository _repository = StayRepository();

  final isLoading = true.obs;
  final properties = <PropertyModel>[].obs;
  final analytics = Rx<StayDashboardAnalytics?>(null);
  final selectedProperty = Rxn<PropertyModel>();
  final pricing = Rxn<StayPricingModel>();
  final availabilityList = <StayAvailabilityModel>[].obs;

  // Add/Edit Property Form Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController(text: 'Guwahati');
  final stateController = TextEditingController(text: 'Assam');
  final priceController = TextEditingController();
  final selectedPropertyType = 'Resort'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final analyticsFuture = _repository.getStayAnalytics();
      final propertiesFuture = _repository.getProperties();

      final results = await Future.wait([analyticsFuture, propertiesFuture]);
      final analyticsRes = results[0] as dynamic;
      final propertiesRes = results[1] as dynamic;

      if (analyticsRes.success && analyticsRes.data != null) {
        analytics.value = analyticsRes.data;
      }
      if (propertiesRes.success && propertiesRes.data != null) {
        properties.assignAll(propertiesRes.data!);
        if (properties.isNotEmpty && selectedProperty.value == null) {
          selectProperty(properties.first);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stay dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectProperty(PropertyModel prop) {
    selectedProperty.value = prop;
    loadPricing(prop.id);
    loadAvailability(prop.id);
  }

  Future<void> loadPricing(String propertyId) async {
    final res = await _repository.getPricing(propertyId);
    if (res.success && res.data != null) {
      pricing.value = res.data;
    }
  }

  Future<void> loadAvailability(String propertyId) async {
    final res = await _repository.getAvailability(propertyId);
    if (res.success && res.data != null) {
      availabilityList.assignAll(res.data!);
    }
  }

  Future<void> submitProperty() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Validation', 'Please fill in property name and base price');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.createProperty({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'property_type': selectedPropertyType.value,
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'base_price_per_night': double.tryParse(priceController.text) ?? 3500,
      });
      if (res.success) {
        Get.snackbar('Success', 'Property created and submitted for verification');
        loadDashboardData();
        Get.offNamed('/stay/properties');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create property');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
