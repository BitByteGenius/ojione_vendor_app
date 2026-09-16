import '../../../shared/enums/service_type.dart';
import '../../../shared/enums/user_role.dart';
import '../../../shared/enums/vendor_status.dart';

class VendorModel {
  final String id;
  final String fullName;
  final String businessName;
  final String aadhaarNumber;
  final String phone;
  final String email;
  final String city;
  final String state;
  final String pincode;
  final String fullAddress;
  final UserRole role;
  final List<ServiceType> assignedServices;
  final List<String> permissions;
  final VendorVerificationStatus verificationStatus;
  final VendorStatus accountStatus;
  final DateTime createdAt;

  VendorModel({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.aadhaarNumber,
    required this.phone,
    required this.email,
    required this.city,
    required this.state,
    required this.pincode,
    required this.fullAddress,
    required this.role,
    required this.assignedServices,
    required this.permissions,
    required this.verificationStatus,
    required this.accountStatus,
    required this.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? json['owner_name'] ?? '',
      businessName: json['business_name'] ?? json['businessName'] ?? '',
      aadhaarNumber: json['aadhaar_number'] ?? json['aadhaarNumber'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      fullAddress: json['full_address'] ?? json['fullAddress'] ?? json['address'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'vendor'),
      assignedServices: (json['assigned_services'] as List<dynamic>? ?? [])
          .map((e) => ServiceType.fromString(e.toString()))
          .toList(),
      permissions: List<String>.from(json['permissions'] ?? []),
      verificationStatus: VendorVerificationStatus.fromString(
        json['verification_status'] ?? 'pending',
      ),
      accountStatus: VendorStatus.fromString(
        json['account_status'] ?? json['status'] ?? 'pending',
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'business_name': businessName,
      'aadhaar_number': aadhaarNumber,
      'phone': phone,
      'email': email,
      'city': city,
      'state': state,
      'pincode': pincode,
      'full_address': fullAddress,
      'role': role.name,
      'assigned_services': assignedServices.map((s) => s.id).toList(),
      'permissions': permissions,
      'verification_status': verificationStatus.name,
      'account_status': accountStatus.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? fullName,
    String? businessName,
    String? aadhaarNumber,
    String? phone,
    String? email,
    String? city,
    String? state,
    String? pincode,
    String? fullAddress,
    UserRole? role,
    List<ServiceType>? assignedServices,
    List<String>? permissions,
    VendorVerificationStatus? verificationStatus,
    VendorStatus? accountStatus,
    DateTime? createdAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      businessName: businessName ?? this.businessName,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      fullAddress: fullAddress ?? this.fullAddress,
      role: role ?? this.role,
      assignedServices: assignedServices ?? this.assignedServices,
      permissions: permissions ?? this.permissions,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      accountStatus: accountStatus ?? this.accountStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
