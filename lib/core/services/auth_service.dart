import 'package:get/get.dart';
import '../../shared/enums/service_type.dart';
import '../../shared/enums/user_role.dart';
import '../../shared/models/permission.dart';
import '../network/api_client.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final RxBool isLoggedIn = true.obs;
  final RxString vendorId = 'VEN-78901'.obs;
  final RxString vendorName = 'Assam Heritage & Hospitality'.obs;
  final RxString ownerName = 'Gunajit Sharma'.obs;
  final RxString email = 'vendor@sewasetu.com'.obs;
  final RxString phone = '+91 98765 43210'.obs;
  final Rx<UserRole> currentRole = UserRole.vendor.obs;

  // Dynamically enabled services for this vendor account
  // Initialized with all 5 services enabled by default, but toggleable dynamically
  final RxSet<ServiceType> assignedServices = <ServiceType>{
    ServiceType.stay,
    ServiceType.trips,
    ServiceType.shop,
    ServiceType.rental,
    ServiceType.localExperiences,
  }.obs;

  // Active permissions for the current user
  final RxList<String> permissions = <String>[...AppPermissions.allPermissions].obs;

  @override
  void onInit() {
    super.onInit();
    // In production, token and vendor profile would be restored from secure storage
    ApiClient.instance.setAuthToken('demo-vendor-jwt-token');
  }

  bool hasService(ServiceType type) {
    return assignedServices.contains(type);
  }

  bool hasPermission(String permission) {
    if (currentRole.value == UserRole.vendor) return true;
    return permissions.contains(permission);
  }

  // Dynamic simulation helpers for testing and demonstration
  void toggleService(ServiceType type) {
    if (assignedServices.contains(type)) {
      if (assignedServices.length > 1) {
        assignedServices.remove(type);
      }
    } else {
      assignedServices.add(type);
    }
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
