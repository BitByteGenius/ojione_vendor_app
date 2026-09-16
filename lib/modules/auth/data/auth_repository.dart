import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/auth_response_model.dart';
import '../models/vendor_model.dart';
import 'auth_data_source.dart';
import 'mock_auth_data_source.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  // Defaults to MockAuthDataSource, backend remote data source can be passed in
  AuthRepository({AuthDataSource? dataSource})
      : _dataSource = dataSource ?? MockAuthDataSource();

  Future<ApiResponse<AuthResponseModel>> login({
    required String emailOrPhone,
    required String password,
  }) {
    return _dataSource.login(emailOrPhone: emailOrPhone, password: password);
  }

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
  }) {
    return _dataSource.register(
      fullName: fullName,
      businessName: businessName,
      aadhaarNumber: aadhaarNumber,
      phone: phone,
      email: email,
      city: city,
      state: state,
      pincode: pincode,
      fullAddress: fullAddress,
      selectedServices: selectedServices,
    );
  }

  Future<ApiResponse<bool>> verifyOtp({
    required String phone,
    required String otp,
  }) {
    return _dataSource.verifyOtp(phone: phone, otp: otp);
  }

  Future<ApiResponse<bool>> forgotPassword(String email) {
    return _dataSource.forgotPassword(email);
  }

  Future<ApiResponse<VendorModel>> getProfile() {
    return _dataSource.getProfile();
  }
}
