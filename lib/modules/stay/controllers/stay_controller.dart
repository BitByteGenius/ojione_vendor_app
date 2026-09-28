import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/stay_type.dart';
import '../data/stay_repository.dart';
import '../models/amenity_model.dart';
import '../models/availability_model.dart';
import '../models/pricing_model.dart';
import '../models/property_image_model.dart';
import '../models/property_model.dart';
import '../models/stay_analytics_model.dart';

class PropertyPhotoItem {
  final String id;
  final String url;
  final String tag; // Bedroom, Bathroom, Kitchen, Exterior, Living Area, Dining
  final bool isCover;

  PropertyPhotoItem({
    required this.id,
    required this.url,
    required this.tag,
    this.isCover = false,
  });

  PropertyPhotoItem copyWith({
    String? id,
    String? url,
    String? tag,
    bool? isCover,
  }) {
    return PropertyPhotoItem(
      id: id ?? this.id,
      url: url ?? this.url,
      tag: tag ?? this.tag,
      isCover: isCover ?? this.isCover,
    );
  }
}

class VendorDocumentUploadItem {
  final String id;
  final String docType;
  final String fileName;
  final String? fileUrl;
  final bool isUploaded;
  final bool isRequired;

  VendorDocumentUploadItem({
    required this.id,
    required this.docType,
    required this.fileName,
    this.fileUrl,
    this.isUploaded = false,
    this.isRequired = true,
  });

  VendorDocumentUploadItem copyWith({
    String? id,
    String? docType,
    String? fileName,
    String? fileUrl,
    bool? isUploaded,
    bool? isRequired,
  }) {
    return VendorDocumentUploadItem(
      id: id ?? this.id,
      docType: docType ?? this.docType,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      isUploaded: isUploaded ?? this.isUploaded,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}

class StayController extends GetxController {
  final StayRepository _repository = StayRepository();

  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final properties = <PropertyModel>[].obs;
  final analytics = Rx<StayDashboardAnalytics?>(null);
  final selectedProperty = Rxn<PropertyModel>();
  final pricing = Rxn<StayPricingModel>();
  final availabilityList = <StayAvailabilityModel>[].obs;

  // Multi-step Wizard Navigation
  final currentStep = 0.obs;
  final totalSteps = 7;
  final maxCompletedStep = 0.obs;

  // Add/Edit Property Form Controllers
  final titleController = TextEditingController(
    text: 'Modern 1BHK in HSR Layout',
  );
  TextEditingController get nameController =>
      titleController; // Alias for backward compatibility
  final descriptionController = TextEditingController(
    text:
        'Spacious and well-ventilated apartment with modern interiors. Situated close to major tech hubs, cafes, and supermarkets. Curfew: 11:00 PM. No loud parties. Smoking allowed only on private balcony.',
  );
  final roomConfigController = TextEditingController(text: '1 BHK');
  final selectedFurnishing = 'Fully Furnished'.obs;

  // Location Controllers
  final addressController = TextEditingController(
    text: '14th Main Rd, Sector 4, HSR Layout',
  );
  final cityController = TextEditingController(text: 'Bengaluru');
  final stateController = TextEditingController(text: 'Karnataka');
  final pincodeController = TextEditingController(text: '560102');
  final nearbyLandmarksController = TextEditingController(
    text: 'Near BDA Complex, 5 mins from Silk Board metro',
  );

  // Pricing & Inventory
  final pricePerNightController = TextEditingController(text: '2200');
  TextEditingController get priceController => pricePerNightController; // Alias
  final pricePerMonthController = TextEditingController(text: '28000');
  final depositAmountController = TextEditingController(text: '10000');
  final availableRooms = 2.obs;
  final maxOccupancy = 2.obs;
  final availableFromDate = Rxn<DateTime>(
    DateTime.now().add(const Duration(days: 1)),
  );
  final checkInTime = '12:00 PM'.obs;
  final checkOutTime = '11:00 AM'.obs;

  // Stay Type & Subtype
  final selectedStayType = StayType.flat.obs;
  final selectedPropertyType = '1BHK'.obs;

  // Coordinates (Map Pin)
  final latitude = 12.9121.obs;
  final longitude = 77.6446.obs;
  final locationPinName = 'HSR Layout, Bengaluru'.obs;

  // Host Profile & Contact
  final hostAvatarUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300'.obs;
  final hostName = 'Gunajit Sharma'.obs;
  final hostPhoneController = TextEditingController(text: '+91 98765 43210');
  final hostEmailController = TextEditingController(
    text: 'vendor.stay@oji.com',
  );

  // Property Photos
  final uploadedPhotos = <PropertyPhotoItem>[
    PropertyPhotoItem(
      id: 'photo-1',
      url: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      tag: 'Exterior',
      isCover: true,
    ),
    PropertyPhotoItem(
      id: 'photo-2',
      url: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      tag: 'Bedroom',
      isCover: false,
    ),
    PropertyPhotoItem(
      id: 'photo-3',
      url: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
      tag: 'Bathroom',
      isCover: false,
    ),
    PropertyPhotoItem(
      id: 'photo-4',
      url: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=800',
      tag: 'Kitchen',
      isCover: false,
    ),
  ].obs;

  // Selected Amenities
  final selectedAmenities = <String>{
    'WiFi',
    'AC',
    'Power Backup',
    'Meals Included',
    'Parking',
    'Geyser',
    'CCTV',
  }.obs;

  // House Rules & Guest Restrictions
  final genderRestriction = 'Unisex / All Guests'.obs;
  final houseRules = <String>{
    'No Smoking inside rooms',
    'Curfew: 11:00 PM',
    'No Loud Parties',
    'Valid Govt ID Required',
  }.obs;
  final customRuleController = TextEditingController();

  // Verification Documents
  final uploadedDocuments = <VendorDocumentUploadItem>[
    VendorDocumentUploadItem(
      id: 'doc-1',
      docType: 'Property Ownership / Lease Agreement',
      fileName: 'ownership_lease_deed.pdf',
      fileUrl: 'https://sewasetu.org/docs/lease_deed.pdf',
      isUploaded: true,
      isRequired: true,
    ),
    VendorDocumentUploadItem(
      id: 'doc-2',
      docType: 'Electricity / Utility Bill',
      fileName: 'electricity_bill_latest.pdf',
      fileUrl: 'https://sewasetu.org/docs/ebill.pdf',
      isUploaded: true,
      isRequired: true,
    ),
    VendorDocumentUploadItem(
      id: 'doc-3',
      docType: 'Government ID Proof (Aadhaar/PAN)',
      fileName: 'vendor_aadhaar_card.pdf',
      fileUrl: 'https://sewasetu.org/docs/aadhaar.pdf',
      isUploaded: true,
      isRequired: true,
    ),
    VendorDocumentUploadItem(
      id: 'doc-4',
      docType: 'Trade License / FSSAI (PG & Mess)',
      fileName: 'trade_license_2026.pdf',
      fileUrl: null,
      isUploaded: false,
      isRequired: false,
    ),
  ].obs;

  // Declaration Checkbox
  final isTermsAgreed = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initVendorProfileDefaults();
    loadDashboardData();
  }

  void _initVendorProfileDefaults() {
    try {
      if (Get.isRegistered<AuthService>()) {
        final auth = AuthService.to;
        final vendor = auth.currentVendor.value;
        if (vendor != null) {
          hostName.value = vendor.fullName.isNotEmpty
              ? vendor.fullName
              : 'Host Vendor';
          if (vendor.phone.isNotEmpty) {
            hostPhoneController.text = vendor.phone;
          }
          if (vendor.email.isNotEmpty) {
            hostEmailController.text = vendor.email;
          }
          if (vendor.city.isNotEmpty) {
            cityController.text = vendor.city;
          }
          if (vendor.state.isNotEmpty) {
            stateController.text = vendor.state;
          }
          if (vendor.fullAddress.isNotEmpty) {
            addressController.text = vendor.fullAddress;
          }
        }
      }
    } catch (_) {}
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

  // Stepper Controls & Validation
  bool validateStep(int step) {
    switch (step) {
      case 0:
        if (titleController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Property title is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        if (descriptionController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Property overview description is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 1:
        if (addressController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Street address is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        if (cityController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'City name is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        if (pincodeController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Pincode is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 2:
        final priceStr = pricePerNightController.text.trim();
        if (priceStr.isEmpty ||
            double.tryParse(priceStr) == null ||
            double.parse(priceStr) <= 0) {
          Get.snackbar(
            'Validation Error',
            'Valid price per night (₹) is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 3:
        if (selectedAmenities.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Please select at least 1 amenity for your property',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 4:
        if (uploadedPhotos.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Please upload at least 1 photo of the property',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 5:
        if (hostPhoneController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Host contact phone number is required',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      case 6:
        if (!isTermsAgreed.value) {
          Get.snackbar(
            'Declaration Required',
            'Please confirm terms & accuracy of information',
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  void nextStep() {
    if (validateStep(currentStep.value)) {
      if (currentStep.value < totalSteps - 1) {
        currentStep.value++;
        if (currentStep.value > maxCompletedStep.value) {
          maxCompletedStep.value = currentStep.value;
        }
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step <= maxCompletedStep.value || step == currentStep.value + 1) {
      if (step > currentStep.value) {
        if (validateStep(currentStep.value)) {
          currentStep.value = step;
        }
      } else {
        currentStep.value = step;
      }
    }
  }

  // Media Actions
  void addPhoto(String url, String tag) {
    final isFirst = uploadedPhotos.isEmpty;
    uploadedPhotos.add(
      PropertyPhotoItem(
        id: 'photo-${DateTime.now().millisecondsSinceEpoch}',
        url: url,
        tag: tag,
        isCover: isFirst,
      ),
    );
  }

  void removePhoto(int index) {
    if (index >= 0 && index < uploadedPhotos.length) {
      final wasCover = uploadedPhotos[index].isCover;
      uploadedPhotos.removeAt(index);
      if (wasCover && uploadedPhotos.isNotEmpty) {
        uploadedPhotos[0] = uploadedPhotos[0].copyWith(isCover: true);
      }
    }
  }

  void setCoverPhoto(int index) {
    for (int i = 0; i < uploadedPhotos.length; i++) {
      uploadedPhotos[i] = uploadedPhotos[i].copyWith(isCover: i == index);
    }
  }

  void updateHostAvatar(String url) {
    hostAvatarUrl.value = url;
    Get.snackbar(
      'Profile Picture Updated',
      'Vendor profile avatar updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Documents Actions
  void toggleDocumentUpload(int index, String fileName) {
    if (index >= 0 && index < uploadedDocuments.length) {
      final item = uploadedDocuments[index];
      final isCurrentlyUploaded = item.isUploaded;
      uploadedDocuments[index] = item.copyWith(
        isUploaded: !isCurrentlyUploaded,
        fileName: !isCurrentlyUploaded ? fileName : 'not_uploaded.pdf',
        fileUrl: !isCurrentlyUploaded
            ? 'https://sewasetu.org/docs/$fileName'
            : null,
      );
    }
  }

  // Location Coordinates
  void setCoordinates({
    required double lat,
    required double lng,
    String? locationName,
  }) {
    latitude.value = lat;
    longitude.value = lng;
    if (locationName != null && locationName.isNotEmpty) {
      locationPinName.value = locationName;
    }
  }

  // Amenities & Rules
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void toggleHouseRule(String rule) {
    if (houseRules.contains(rule)) {
      houseRules.remove(rule);
    } else {
      houseRules.add(rule);
    }
  }

  void addCustomHouseRule() {
    final rule = customRuleController.text.trim();
    if (rule.isNotEmpty) {
      houseRules.add(rule);
      customRuleController.clear();
    }
  }

  // Inventory Steppers
  void incrementRooms() {
    availableRooms.value++;
  }

  void decrementRooms() {
    if (availableRooms.value > 1) {
      availableRooms.value--;
    }
  }

  void incrementOccupancy() {
    maxOccupancy.value++;
  }

  void decrementOccupancy() {
    if (maxOccupancy.value > 1) {
      maxOccupancy.value--;
    }
  }

  // Save Draft Workflow
  void saveDraft() {
    final title = titleController.text.trim().isNotEmpty
        ? titleController.text.trim()
        : 'Draft Stay Listing';
    final nightPrice =
        double.tryParse(pricePerNightController.text.trim()) ?? 0.0;
    final monthPrice = double.tryParse(pricePerMonthController.text.trim());
    final deposit = double.tryParse(depositAmountController.text.trim());

    final draftProp = PropertyModel(
      id: 'prop-draft-${DateTime.now().millisecondsSinceEpoch}',
      name: '$title (Draft)',
      description: descriptionController.text.trim(),
      propertyType: selectedPropertyType.value,
      stayType: selectedStayType.value,
      roomConfiguration: roomConfigController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      pincode: pincodeController.text.trim(),
      latitude: latitude.value,
      longitude: longitude.value,
      hostAvatarUrl: hostAvatarUrl.value,
      hostName: hostName.value,
      hostPhone: hostPhoneController.text.trim(),
      hostEmail: hostEmailController.text.trim(),
      depositAmount: deposit,
      furnishingStatus: selectedFurnishing.value,
      availableFrom: availableFromDate.value
          ?.toIso8601String()
          .split('T')
          .first,
      maxOccupancy: maxOccupancy.value,
      houseRules: houseRules.toList(),
      requiredDocuments: uploadedDocuments
          .where((d) => d.isUploaded)
          .map((d) => d.docType)
          .toList(),
      checkInTime: checkInTime.value,
      checkOutTime: checkOutTime.value,
      status: 'draft',
      basePricePerNight: nightPrice,
      pricePerMonth: monthPrice,
      availableRooms: availableRooms.value,
      rooms: [],
      amenities: selectedAmenities
          .map(
            (a) => AmenityModel(
              id: a,
              name: a,
              icon: 'check_circle',
              category: 'General',
            ),
          )
          .toList(),
      images: uploadedPhotos
          .map(
            (p) => PropertyImageModel(
              id: p.id,
              url: p.url,
              isFeatured: p.isCover,
              caption: p.tag,
            ),
          )
          .toList(),
      createdAt: DateTime.now(),
    );

    properties.insert(0, draftProp);
    selectedProperty.value = draftProp;

    Get.snackbar(
      'Draft Saved!',
      'Your property listing draft has been saved locally.',
      backgroundColor: Colors.amber.shade800,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Form Submission
  Future<void> submitProperty() async {
    for (int i = 0; i < totalSteps; i++) {
      if (!validateStep(i)) {
        currentStep.value = i;
        return;
      }
    }

    final title = titleController.text.trim();
    final priceStr = pricePerNightController.text.trim();

    try {
      isSubmitting.value = true;
      final nightPrice = double.parse(priceStr);
      final monthPrice = double.tryParse(pricePerMonthController.text.trim());
      final deposit = double.tryParse(depositAmountController.text.trim());

      final newPropertyData = {
        'title': title,
        'name': title,
        'description': descriptionController.text.trim(),
        'stay_type': selectedStayType.value.id,
        'property_type': selectedPropertyType.value,
        'room_configuration': roomConfigController.text.trim(),
        'furnishing_status': selectedFurnishing.value,
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'pincode': pincodeController.text.trim(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        'host': {
          'name': hostName.value,
          'avatarUrl': hostAvatarUrl.value,
          'phone': hostPhoneController.text.trim(),
          'email': hostEmailController.text.trim(),
        },
        'host_avatar_url': hostAvatarUrl.value,
        'host_name': hostName.value,
        'host_phone': hostPhoneController.text.trim(),
        'host_email': hostEmailController.text.trim(),
        'price_per_night': nightPrice,
        'base_price_per_night': nightPrice,
        'price_per_month': monthPrice,
        'deposit_amount': deposit,
        'available_rooms': availableRooms.value,
        'max_occupancy': maxOccupancy.value,
        'available_from': availableFromDate.value
            ?.toIso8601String()
            .split('T')
            .first,
        'check_in_time': checkInTime.value,
        'check_out_time': checkOutTime.value,
        'house_rules': houseRules.toList(),
        'amenities': selectedAmenities
            .map((a) => {'id': a, 'name': a, 'category': 'General'})
            .toList(),
        'images': uploadedPhotos
            .map(
              (p) => {
                'id': p.id,
                'url': p.url,
                'caption': p.tag,
                'is_featured': p.isCover,
              },
            )
            .toList(),
        'required_documents': uploadedDocuments
            .where((d) => d.isUploaded)
            .map((d) => d.docType)
            .toList(),
      };

      final res = await _repository.createProperty(newPropertyData);
      if (res.success) {
        final newProp = PropertyModel(
          id: 'prop-new-${DateTime.now().millisecondsSinceEpoch}',
          name: title,
          description: descriptionController.text.trim(),
          propertyType: selectedPropertyType.value,
          stayType: selectedStayType.value,
          roomConfiguration: roomConfigController.text.trim(),
          address: addressController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          pincode: pincodeController.text.trim(),
          latitude: latitude.value,
          longitude: longitude.value,
          hostAvatarUrl: hostAvatarUrl.value,
          hostName: hostName.value,
          hostPhone: hostPhoneController.text.trim(),
          hostEmail: hostEmailController.text.trim(),
          depositAmount: deposit,
          furnishingStatus: selectedFurnishing.value,
          availableFrom: availableFromDate.value
              ?.toIso8601String()
              .split('T')
              .first,
          maxOccupancy: maxOccupancy.value,
          houseRules: houseRules.toList(),
          requiredDocuments: uploadedDocuments
              .where((d) => d.isUploaded)
              .map((d) => d.docType)
              .toList(),
          checkInTime: checkInTime.value,
          checkOutTime: checkOutTime.value,
          status: 'pending_approval',
          basePricePerNight: nightPrice,
          pricePerMonth: monthPrice,
          availableRooms: availableRooms.value,
          rooms: [],
          amenities: selectedAmenities
              .map(
                (a) => AmenityModel(
                  id: a,
                  name: a,
                  icon: 'check_circle',
                  category: 'General',
                ),
              )
              .toList(),
          images: uploadedPhotos
              .map(
                (p) => PropertyImageModel(
                  id: p.id,
                  url: p.url,
                  isFeatured: p.isCover,
                  caption: p.tag,
                ),
              )
              .toList(),
          createdAt: DateTime.now(),
        );

        properties.insert(0, newProp);
        selectedProperty.value = newProp;

        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.verified_rounded, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text('Listing Submitted!'),
              ],
            ),
            content: Text(
              'Your property "$title" has been submitted successfully for verification.\n\nStatus: Pending Admin Approval.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.offNamed('/stay/properties');
                },
                child: const Text('View All Properties'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.offNamed('/stay/properties/details', arguments: newProp);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Property Details'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      Get.snackbar('Submission Error', 'Failed to submit property listing: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void togglePropertyStatus(PropertyModel property) {
    final index = properties.indexWhere((p) => p.id == property.id);
    if (index != -1) {
      final isCurrentlyActive =
          property.status == 'published' || property.status == 'active';
      final newStatus = isCurrentlyActive ? 'inactive' : 'published';
      properties[index] = property.copyWith(status: newStatus);
      if (selectedProperty.value?.id == property.id) {
        selectedProperty.value = properties[index];
      }
      Get.snackbar(
        'Property Status Updated',
        '${property.name} is now ${isCurrentlyActive ? 'Deactivated' : 'Active & Published'}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void deleteProperty(String propertyId) {
    final target = properties.firstWhereOrNull((p) => p.id == propertyId);
    if (target != null) {
      properties.removeWhere((p) => p.id == propertyId);
      if (selectedProperty.value?.id == propertyId) {
        selectedProperty.value = properties.isNotEmpty
            ? properties.first
            : null;
      }
      Get.snackbar(
        'Property Deleted',
        '${target.name} has been removed from your catalog',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    roomConfigController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    nearbyLandmarksController.dispose();
    pricePerNightController.dispose();
    pricePerMonthController.dispose();
    depositAmountController.dispose();
    hostPhoneController.dispose();
    hostEmailController.dispose();
    customRuleController.dispose();
    super.onClose();
  }
}
