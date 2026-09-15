import '../../../shared/enums/service_type.dart';
import '../../../shared/enums/user_role.dart';

class VendorModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;
  final UserRole role;
  final List<ServiceType> assignedServices;
  final List<String> permissions;
  final String verificationStatus;
  final DateTime createdAt;

  VendorModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.role,
    required this.assignedServices,
    required this.permissions,
    required this.verificationStatus,
    required this.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      businessName: json['business_name'] ?? json['businessName'] ?? '',
      ownerName: json['owner_name'] ?? json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'vendor'),
      assignedServices: (json['assigned_services'] as List<dynamic>? ?? [])
          .map((e) => ServiceType.fromString(e.toString()))
          .toList(),
      permissions: List<String>.from(json['permissions'] ?? []),
      verificationStatus: json['verification_status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'role': role.name,
      'assigned_services': assignedServices.map((s) => s.id).toList(),
      'permissions': permissions,
      'verification_status': verificationStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
