import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/auth_response_model.dart';
import '../models/vendor_model.dart';

abstract class AuthDataSource {
  Future<ApiResponse<AuthResponseModel>> login({
    required String emailOrPhone,
    required String password,
  });

  Future<ApiResponse<VendorModel>> register({
    required String fullName,
    required String businessName,
    required String aadhaarNumber,
    required String phone,
    required String email,
    required String city,
    required String state,
    required String pincode,
    required String fullAddress,
    required List<ServiceType> selectedServices,
  });

  Future<ApiResponse<bool>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<ApiResponse<bool>> forgotPassword(String email);

  Future<ApiResponse<VendorModel>> getProfile();
}
