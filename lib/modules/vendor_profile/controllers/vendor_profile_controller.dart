import 'package:get/get.dart';
import '../data/vendor_profile_repository.dart';
import '../models/vendor_profile_model.dart';

class VendorProfileController extends GetxController {
  final VendorProfileRepository _repository = VendorProfileRepository();

  final isLoading = true.obs;
  final profile = Rxn<VendorProfileModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final res = await _repository.getProfile();
      if (res.success && res.data != null) {
        profile.value = res.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load vendor profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final res = await _repository.updateProfile(data);
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadProfile();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }
}
