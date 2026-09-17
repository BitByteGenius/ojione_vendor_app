import 'package:get/get.dart';
import '../../modules/auth/data/mock_vendor_profiles.dart';
import '../../modules/auth/models/vendor_model.dart';
import '../../shared/enums/service_type.dart';
import '../../shared/enums/user_role.dart';
import '../../shared/enums/vendor_status.dart';
import '../../shared/models/permission.dart';
import '../network/api_client.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final RxBool isLoggedIn = true.obs;
  final Rx<VendorModel?> currentVendor = Rx<VendorModel?>(null);

  final RxString vendorId = MockVendorProfiles.vendorA.id.obs;
  final RxString vendorName = MockVendorProfiles.vendorA.businessName.obs;
  final RxString ownerName = MockVendorProfiles.vendorA.ownerName.obs;
  final RxString email = MockVendorProfiles.vendorA.email.obs;
  final RxString phone = MockVendorProfiles.vendorA.phone.obs;
  final RxString aadhaarNumber = MockVendorProfiles.vendorA.aadhaarNumber.obs;
  final RxString city = MockVendorProfiles.vendorA.city.obs;
  final RxString state = MockVendorProfiles.vendorA.state.obs;
  final RxString pincode = MockVendorProfiles.vendorA.pincode.obs;
  final RxString address = MockVendorProfiles.vendorA.address.obs;

  final Rx<VendorVerificationStatus> verificationStatus =
      VendorVerificationStatus.verified.obs;
  final Rx<VendorStatus> accountStatus = VendorStatus.approved.obs;
  final Rx<UserRole> currentRole = UserRole.vendor.obs;

  // Currently focused service (for topbar quick badge / switcher)
  final Rx<ServiceType?> activeService = Rx<ServiceType?>(ServiceType.stay);

  // Dynamically enabled services for this vendor account
  // Initialized with Stay and Rental as default demo, strictly configurable
  final RxSet<ServiceType> assignedServices = <ServiceType>{
    ServiceType.stay,
    ServiceType.rental,
  }.obs;

  final RxList<String> permissions = <String>[...AppPermissions.allPermissions].obs;

  @override
  void onInit() {
    super.onInit();
    ApiClient.instance.setAuthToken('demo-vendor-jwt-token');
    _syncVendorModel();
  }

  void _syncVendorModel() {
    currentVendor.value = VendorModel(
      id: vendorId.value,
      fullName: ownerName.value,
      businessName: vendorName.value,
      aadhaarNumber: aadhaarNumber.value,
      phone: phone.value,
      email: email.value,
      city: city.value,
      state: state.value,
      pincode: pincode.value,
      fullAddress: address.value,
      role: currentRole.value,
      assignedServices: assignedServices.toList(),
      permissions: permissions.toList(),
      verificationStatus: verificationStatus.value,
      accountStatus: accountStatus.value,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    );
  }

  bool hasService(ServiceType type) {
    return assignedServices.contains(type);
  }

  bool hasPermission(String permission) {
    if (currentRole.value == UserRole.vendor) return true;
    return permissions.contains(permission);
  }

  void setActiveService(ServiceType type) {
    if (assignedServices.contains(type)) {
      activeService.value = type;
    }
  }

  // Activate registered vendor after registration flow
  void setRegisteredVendor(VendorModel vendor) {
    currentVendor.value = vendor;
    vendorId.value = vendor.id;
    vendorName.value = vendor.businessName;
    ownerName.value = vendor.fullName;
    email.value = vendor.email;
    phone.value = vendor.phone;
    aadhaarNumber.value = vendor.aadhaarNumber;
    city.value = vendor.city;
    state.value = vendor.state;
    pincode.value = vendor.pincode;
    address.value = vendor.fullAddress;
    verificationStatus.value = vendor.verificationStatus;
    accountStatus.value = vendor.accountStatus;
    assignedServices.assignAll(vendor.assignedServices);

    if (vendor.assignedServices.isNotEmpty) {
      activeService.value = vendor.assignedServices.first;
    } else {
      activeService.value = null;
    }
  }

  // Apply a mock vendor profile dynamically to test service isolation
  void applyVendorProfile(MockVendorProfile profile) {
    vendorId.value = profile.id;
    vendorName.value = profile.businessName;
    ownerName.value = profile.ownerName;
    email.value = profile.email;
    phone.value = profile.phone;
    aadhaarNumber.value = profile.aadhaarNumber;
    city.value = profile.city;
    state.value = profile.state;
    pincode.value = profile.pincode;
    address.value = profile.address;
    verificationStatus.value = profile.verificationStatus;
    accountStatus.value = profile.accountStatus;
    assignedServices.assignAll(profile.services);
    activeService.value = profile.activeService;
    _syncVendorModel();
  }

  // Demo profile switchers to instantly test strict service separation
  void setDemoVendorAStayRental() => applyVendorProfile(MockVendorProfiles.vendorA);
  void setDemoVendorBShopOnly() => applyVendorProfile(MockVendorProfiles.vendorB);
  void setDemoVendorCTripsExperiences() => applyVendorProfile(MockVendorProfiles.vendorC);
  void setDemoVendorDStayShopExperiences() => applyVendorProfile(MockVendorProfiles.vendorD);

  void setRole(UserRole role) {
    currentRole.value = role;
    switch (role) {
      case UserRole.vendor:
        permissions.assignAll(AppPermissions.allPermissions);
        break;
      case UserRole.vendorManager:
        permissions.assignAll(AppPermissions.managerPermissions);
        break;
      case UserRole.vendorStaff:
        permissions.assignAll(AppPermissions.staffPermissions);
        break;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    ApiClient.instance.setAuthToken(null);
    Get.offAllNamed('/login');
  }

  void login({required String token, required List<ServiceType> services, required UserRole role}) {
    isLoggedIn.value = true;
    ApiClient.instance.setAuthToken(token);
    assignedServices.assignAll(services);
    setRole(role);
    Get.offAllNamed('/dashboard');
  }
}
