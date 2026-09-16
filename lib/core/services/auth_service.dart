import 'package:get/get.dart';
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

  final RxString vendorId = 'VEN-78901'.obs;
  final RxString vendorName = 'Assam Heritage & Hospitality'.obs;
  final RxString ownerName = 'Gunajit Sharma'.obs;
  final RxString email = 'vendor@sewasetu.com'.obs;
  final RxString phone = '+91 98765 43210'.obs;
  final RxString aadhaarNumber = '7890 1234 5678'.obs;
  final RxString city = 'Guwahati'.obs;
  final RxString state = 'Assam'.obs;
  final RxString pincode = '781001'.obs;
  final RxString address = 'Plot 42, Brahmaputra View Road, Uzanbazar'.obs;

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

  // Demo profile switchers to instantly test strict service separation
  void setDemoVendorA_StayRental() {
    vendorId.value = 'VEN-DEMO-A';
    vendorName.value = 'Kaziranga Eco-Stay & Car Rentals';
    ownerName.value = 'Gunajit Sharma';
    email.value = 'gunajit@kazirangastay.in';
    phone.value = '+91 98765 43210';
    aadhaarNumber.value = '7890 1234 5678';
    city.value = 'Kaziranga';
    state.value = 'Assam';
    pincode.value = '785609';
    address.value = 'Kohora Range, NH-37, Kaziranga';
    assignedServices.assignAll([ServiceType.stay, ServiceType.rental]);
    activeService.value = ServiceType.stay;
    _syncVendorModel();
  }

  void setDemoVendorB_ShopOnly() {
    vendorId.value = 'VEN-DEMO-B';
    vendorName.value = 'Pragjyotish Assam Silk & Craft Store';
    ownerName.value = 'Ananya Goswami';
    email.value = 'ananya@pragjyotishcrafts.com';
    phone.value = '+91 94350 11223';
    aadhaarNumber.value = '4521 8890 2341';
    city.value = 'Guwahati';
    state.value = 'Assam';
    pincode.value = '781003';
    address.value = 'Shop 14, Panbazar Market Complex, Guwahati';
    assignedServices.assignAll([ServiceType.shop]);
    activeService.value = ServiceType.shop;
    _syncVendorModel();
  }

  void setDemoVendorC_TripsExperiences() {
    vendorId.value = 'VEN-DEMO-C';
    vendorName.value = 'Brahmaputra Expeditions & Cultural Walks';
    ownerName.value = 'Bikramjit Saikia';
    email.value = 'bikram@brahmaputraexpeditions.in';
    phone.value = '+91 91270 55667';
    aadhaarNumber.value = '3344 7788 9900';
    city.value = 'Jorhat';
    state.value = 'Assam';
    pincode.value = '785001';
    address.value = 'Gar-Ali Heritage Lane, Jorhat';
    assignedServices.assignAll([ServiceType.trips, ServiceType.localExperiences]);
    activeService.value = ServiceType.trips;
    _syncVendorModel();
  }

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
