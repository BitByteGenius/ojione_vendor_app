import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';
import '../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  // Text Controllers
  final emailController = TextEditingController(text: 'vendor@sewasetu.com');
  final passwordController = TextEditingController(text: 'password123');
  final businessNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // State
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = true.obs;

  // Selected services during registration
  final selectedServices = <ServiceType>{
    ServiceType.stay,
  }.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleServiceSelection(ServiceType type) {
    if (selectedServices.contains(type)) {
      if (selectedServices.length > 1) {
        selectedServices.remove(type);
      }
    } else {
      selectedServices.add(type);
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email/phone and password');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repository.login(emailOrPhone: email, password: password);
      if (response.success && response.data != null) {
        final data = response.data!;
        AuthService.to.login(
          token: data.accessToken,
          services: data.vendor.assignedServices,
          role: data.vendor.role,
        );
        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar('Login Failed', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (businessNameController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return;
    }

    try {
      isLoading.value = true;
      final res = await _repository.register(
        businessName: businessNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        selectedServices: selectedServices.toList(),
      );
      if (res.success) {
        Get.toNamed('/otp', arguments: {'phone': phoneController.text.trim()});
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length < 4) {
      Get.snackbar('Error', 'Please enter a valid OTP');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.verifyOtp(
        phone: phoneController.text.trim(),
        otp: otpController.text.trim(),
      );
      if (res.success) {
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.forgotPassword(emailController.text.trim());
      if (res.success) {
        Get.snackbar('Success', res.message);
        Get.toNamed('/login');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    businessNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
