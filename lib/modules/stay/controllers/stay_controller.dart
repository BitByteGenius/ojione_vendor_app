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
  final String tag; // Bedroom, Bathroom, Kitchen, Exterior, Living Area
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

class StayController extends GetxController {
  final StayRepository _repository = StayRepository();

  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final properties = <PropertyModel>[].obs;
  final analytics = Rx<StayDashboardAnalytics?>(null);
  final selectedProperty = Rxn<PropertyModel>();
  final pricing = Rxn<StayPricingModel>();
  final availabilityList = <StayAvailabilityModel>[].obs;

  // Add/Edit Property Form Controllers
  final titleController = TextEditingController(text: 'Modern 1BHK in HSR Layout');
  TextEditingController get nameController => titleController; // Alias for backward compatibility
  final descriptionController = TextEditingController(
    text: 'Spacious and well-ventilated apartment with modern interiors. Situated close to major tech hubs, cafes, and supermarkets. Curfew: 11:00 PM. No loud parties. Smoking allowed only on private balcony.',
  );
  final roomConfigController = TextEditingController(text: '1 BHK');
  final addressController = TextEditingController(text: '14th Main Rd, Sector 4, HSR Layout');
  final cityController = TextEditingController(text: 'Bengaluru');
  final stateController = TextEditingController(text: 'Karnataka');
  final pincodeController = TextEditingController(text: '560102');

  // Pricing & Availability
  final pricePerNightController = TextEditingController(text: '2200');
  TextEditingController get priceController => pricePerNightController; // Alias
  final pricePerMonthController = TextEditingController(text: '28000');
  final availableRooms = 2.obs;

  // Stay Type
  final selectedStayType = StayType.flat.obs;
  final selectedPropertyType = 'Homestay'.obs;

  // Coordinates (Map Pin)
  final latitude = 12.9121.obs;
  final longitude = 77.6446.obs;
  final locationPinName = 'HSR Layout, Bengaluru'.obs;

  // Host Profile
  final hostAvatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300'.obs;
  final hostName = 'Gunajit Sharma'.obs;

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
          hostName.value = vendor.fullName.isNotEmpty ? vendor.fullName : 'Host Vendor';
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
    Get.snackbar('Profile Picture Updated', 'Vendor profile avatar updated successfully',
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
  }

  // Location Coordinates
  void setCoordinates({required double lat, required double lng, String? locationName}) {
    latitude.value = lat;
    longitude.value = lng;
    if (locationName != null && locationName.isNotEmpty) {
      locationPinName.value = locationName;
    }
  }

  // Amenities
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
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

  // Form Submission
  Future<void> submitProperty() async {
    final title = titleController.text.trim();
    final priceStr = pricePerNightController.text.trim();

    if (title.isEmpty) {
      Get.snackbar('Title Required', 'Please enter a catchy property title (e.g. Modern 1BHK in HSR Layout)');
      return;
    }

    if (priceStr.isEmpty || double.tryParse(priceStr) == null) {
      Get.snackbar('Valid Price Required', 'Please provide a valid nightly booking price');
      return;
    }

    if (uploadedPhotos.isEmpty) {
      Get.snackbar('Photos Required', 'Please upload at least 1 photo of the property');
      return;
    }

    try {
      isSubmitting.value = true;
      final nightPrice = double.parse(priceStr);
      final monthPrice = double.tryParse(pricePerMonthController.text.trim());

      final newPropertyData = {
        'title': title,
        'name': title,
        'description': descriptionController.text.trim(),
        'stay_type': selectedStayType.value.id,
        'property_type': selectedStayType.value.displayName,
        'room_configuration': roomConfigController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'pincode': pincodeController.text.trim(),
        'latitude': latitude.value,
        'longitude': longitude.value,
        'host': {
          'name': hostName.value,
          'avatarUrl': hostAvatarUrl.value,
        },
        'host_avatar_url': hostAvatarUrl.value,
        'host_name': hostName.value,
        'price_per_night': nightPrice,
        'base_price_per_night': nightPrice,
        'price_per_month': monthPrice,
        'available_rooms': availableRooms.value,
        'amenities': selectedAmenities.map((a) => {'id': a, 'name': a, 'category': 'General'}).toList(),
        'images': uploadedPhotos.map((p) => {
          'id': p.id,
          'url': p.url,
          'caption': p.tag,
          'is_featured': p.isCover,
        }).toList(),
      };

      final res = await _repository.createProperty(newPropertyData);
      if (res.success) {
        // Also prepend locally for instant UI responsiveness
        final newProp = PropertyModel(
          id: 'prop-new-${DateTime.now().millisecondsSinceEpoch}',
          name: title,
          description: descriptionController.text.trim(),
          propertyType: selectedStayType.value.displayName,
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
          status: 'pending_approval',
          basePricePerNight: nightPrice,
          pricePerMonth: monthPrice,
          availableRooms: availableRooms.value,
          rooms: [],
          amenities: selectedAmenities.map((a) => AmenityModel(id: a, name: a, icon: 'check_circle', category: 'General')).toList(),
          images: uploadedPhotos.map((p) => PropertyImageModel(id: p.id, url: p.url, isFeatured: p.isCover, caption: p.tag)).toList(),
          createdAt: DateTime.now(),
        );

        properties.insert(0, newProp);
        selectedProperty.value = newProp;

        Get.snackbar(
          'Listing Submitted!',
          'Your property "$title" has been submitted for admin verification.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );

        Get.offNamed('/stay/properties');
      }
    } catch (e) {
      Get.snackbar('Submission Error', 'Failed to submit property listing: $e');
    } finally {
      isSubmitting.value = false;
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
    pricePerNightController.dispose();
    pricePerMonthController.dispose();
    super.onClose();
  }
}
