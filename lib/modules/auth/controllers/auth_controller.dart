import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/enums/service_type.dart';
import '../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  // Registration Step (0: Personal, 1: Address, 2: Services, 3: Review)
  final currentStep = 0.obs;

  // Personal Info Controllers
  final fullNameController = TextEditingController(text: 'Gunajit Sharma');
  final businessNameController = TextEditingController(text: 'Assam Heritage Retreat & Rentals');
  final aadhaarController = TextEditingController(text: '7890 1234 5678');
  final phoneController = TextEditingController(text: '9876543210');
  final emailController = TextEditingController(text: 'gunajit.sharma@gmail.com');

  // Address Controllers
  final cityController = TextEditingController(text: 'Guwahati');
  final stateController = TextEditingController(text: 'Assam');
  final pincodeController = TextEditingController(text: '781001');
  final addressController = TextEditingController(text: 'Plot 42, Riverside Heritage Road, Uzanbazar');

  // Login Controllers
  final loginEmailController = TextEditingController(text: 'vendor@sewasetu.com');
  final loginPasswordController = TextEditingController(text: 'password123');
  final otpController = TextEditingController();

  // State
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final termsAccepted = true.obs;

  // Selected services during registration (Allows 1 or multiple)
  final selectedServices = <ServiceType>{
    ServiceType.stay,
    ServiceType.rental,
  }.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleServiceSelection(ServiceType type) {
    if (selectedServices.contains(type)) {
      if (selectedServices.length > 1) {
        selectedServices.remove(type);
      } else {
        Get.snackbar(
          'Service Required',
          'A vendor must offer at least one service.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      selectedServices.add(type);
    }
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (fullNameController.text.trim().isEmpty ||
          aadhaarController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty) {
        Get.snackbar('Missing Details', 'Please fill in all personal information fields.');
        return;
      }
      if (aadhaarController.text.trim().replaceAll(' ', '').length < 12) {
        Get.snackbar('Invalid Aadhaar', 'Aadhaar number must be 12 digits.');
        return;
      }
    } else if (currentStep.value == 1) {
      if (cityController.text.trim().isEmpty ||
          stateController.text.trim().isEmpty ||
          pincodeController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty) {
        Get.snackbar('Missing Details', 'Please provide complete address details.');
        return;
      }
    } else if (currentStep.value == 2) {
      if (selectedServices.isEmpty) {
        Get.snackbar('Select Services', 'Please select at least one service to offer.');
        return;
      }
    }

    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> submitRegistration() async {
    if (!termsAccepted.value) {
      Get.snackbar('Agreement Required', 'Please accept the Vendor Terms of Service & Privacy Policy.');
      return;
    }

    try {
      isLoading.value = true;
      final res = await _repository.register(
        fullName: fullNameController.text.trim(),
        businessName: businessNameController.text.trim(),
        aadhaarNumber: aadhaarController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        fullAddress: addressController.text.trim(),
        selectedServices: selectedServices.toList(),
      );

      if (res.success && res.data != null) {
        // Activate vendor in AuthService
        AuthService.to.setRegisteredVendor(res.data!);
        Get.toNamed('/registration-success', arguments: res.data);
      } else {
        Get.snackbar('Registration Failed', res.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email/phone and password');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repository.login(emailOrPhone: email, password: password);
      if (response.success && response.data != null) {
        final data = response.data!;
        AuthService.to.setRegisteredVendor(data.vendor);
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
    fullNameController.dispose();
    businessNameController.dispose();
    aadhaarController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
