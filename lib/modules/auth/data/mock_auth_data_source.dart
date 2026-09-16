import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../../../shared/enums/user_role.dart';
import '../../../shared/enums/vendor_status.dart';
import '../../../shared/models/permission.dart';
import '../models/auth_response_model.dart';
import '../models/vendor_model.dart';
import 'auth_data_source.dart';

class MockAuthDataSource implements AuthDataSource {
  // In-memory registered vendor (updated upon registration)
  VendorModel? _currentVendor;

  MockAuthDataSource() {
    _currentVendor = VendorModel(
      id: 'VEN-2026-8891',
      fullName: 'Gunajit Sharma',
      businessName: 'Assam Heritage & Eco Hospitality',
      aadhaarNumber: '7890 1234 5678',
      phone: '+91 98765 43210',
      email: 'vendor@sewasetu.com',
      city: 'Guwahati',
      state: 'Assam',
      pincode: '781001',
      fullAddress: 'Plot 42, Brahmaputra View Road, Uzanbazar',
      role: UserRole.vendor,
      assignedServices: [
        ServiceType.stay,
        ServiceType.rental,
      ],
      permissions: AppPermissions.allPermissions,
      verificationStatus: VendorVerificationStatus.verified,
      accountStatus: VendorStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  @override
  Future<ApiResponse<AuthResponseModel>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    // Preset demo accounts for quick testing
    final vendor = _currentVendor ??
        VendorModel(
          id: 'VEN-2026-8891',
          fullName: 'Gunajit Sharma',
          businessName: 'Assam Heritage & Eco Hospitality',
          aadhaarNumber: '7890 1234 5678',
          phone: '+91 98765 43210',
          email: emailOrPhone,
          city: 'Guwahati',
          state: 'Assam',
          pincode: '781001',
          fullAddress: 'Plot 42, Brahmaputra View Road, Uzanbazar',
          role: UserRole.vendor,
          assignedServices: [ServiceType.stay, ServiceType.rental],
          permissions: AppPermissions.allPermissions,
          verificationStatus: VendorVerificationStatus.verified,
          accountStatus: VendorStatus.approved,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
        );

    final response = AuthResponseModel(
      accessToken: 'mock-jwt-vendor-${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock-refresh-token',
      expiresIn: 86400,
      vendor: vendor,
    );

    return ApiResponse.success(data: response, message: 'Login successful');
  }

  @override
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
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newVendor = VendorModel(
      id: 'VEN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      fullName: fullName,
      businessName: businessName.isNotEmpty ? businessName : '$fullName Enterprises',
      aadhaarNumber: aadhaarNumber,
      phone: phone,
      email: email,
      city: city,
      state: state,
      pincode: pincode,
      fullAddress: fullAddress,
      role: UserRole.vendor,
      assignedServices: selectedServices.isNotEmpty ? selectedServices : [ServiceType.stay],
      permissions: AppPermissions.allPermissions,
      verificationStatus: VendorVerificationStatus.pendingReview,
      accountStatus: VendorStatus.approved, // allow immediate preview of dashboard
      createdAt: DateTime.now(),
    );

    _currentVendor = newVendor;

    return ApiResponse.success(
      data: newVendor,
      message: 'Registration successful! Verification under review.',
    );
  }

  @override
  Future<ApiResponse<bool>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'OTP verified successfully');
  }

  @override
  Future<ApiResponse<bool>> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(
      data: true,
      message: 'Password reset link sent to $email',
    );
  }

  @override
  Future<ApiResponse<VendorModel>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.success(data: _currentVendor!);
  }
}
