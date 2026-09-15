import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/enums/user_role.dart';
import '../models/auth_response_model.dart';
import '../models/vendor_model.dart';

class AuthRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<AuthResponseModel>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    // In production, this calls the actual backend:
    // final response = await _apiClient.post(ApiEndpoints.login, data: {'username': emailOrPhone, 'password': password});
    // return ApiResponse.fromJson(response.data, (json) => AuthResponseModel.fromJson(json));

    // Backend-ready simulated response
    await Future.delayed(const Duration(milliseconds: 600));
    final mockVendor = VendorModel(
      id: 'VEN-2024-001',
      businessName: 'Assam Heritage & Hospitality Group',
      ownerName: 'Gunajit Sharma',
      email: emailOrPhone.contains('@') ? emailOrPhone : 'vendor@sewasetu.com',
      phone: '+91 98765 43210',
      role: UserRole.vendor,
      assignedServices: [
        ServiceType.stay,
        ServiceType.trips,
        ServiceType.shop,
        ServiceType.rental,
        ServiceType.localExperiences,
      ],
      permissions: ['*'],
      verificationStatus: 'verified',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );

    final authResponse = AuthResponseModel(
      accessToken: 'jwt_access_token_demo_xyz_123',
      refreshToken: 'jwt_refresh_token_demo_abc_789',
      expiresIn: 86400,
      vendor: mockVendor,
    );

    return ApiResponse.success(data: authResponse, message: 'Login successful');
  }

  Future<ApiResponse<bool>> register({
    required String businessName,
    required String ownerName,
    required String email,
    required String phone,
    required List<ServiceType> selectedServices,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ApiResponse.success(data: true, message: 'Registration submitted. Please verify OTP.');
  }

  Future<ApiResponse<bool>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success(data: true, message: 'OTP verified successfully');
  }

  Future<ApiResponse<bool>> forgotPassword(String emailOrPhone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success(data: true, message: 'Password reset link sent to your registered contact.');
  }
}
