import '../../../shared/enums/service_type.dart';
import 'business_model.dart';
import 'vendor_document_model.dart';

class VendorProfileModel {
  final String id;
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;
  final String alternatePhone;
  final String profileImageUrl;
  final String verificationStatus; // 'verified', 'pending', 'rejected'
  final List<ServiceType> assignedServices;
  final BusinessModel business;
  final List<VendorDocumentModel> documents;
  final double rating;
  final int totalReviews;

  VendorProfileModel({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.alternatePhone,
    required this.profileImageUrl,
    required this.verificationStatus,
    required this.assignedServices,
    required this.business,
    required this.documents,
    required this.rating,
    required this.totalReviews,
  });

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) {
    return VendorProfileModel(
      id: json['id'] ?? '',
      businessName: json['business_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      alternatePhone: json['alternate_phone'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      verificationStatus: json['verification_status'] ?? 'pending',
      assignedServices: (json['assigned_services'] as List<dynamic>? ?? [])
          .map((e) => ServiceType.fromString(e.toString()))
          .toList(),
      business: BusinessModel.fromJson(json['business'] ?? {}),
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((e) => VendorDocumentModel.fromJson(e))
          .toList(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'alternate_phone': alternatePhone,
      'profile_image_url': profileImageUrl,
      'verification_status': verificationStatus,
      'assigned_services': assignedServices.map((s) => s.id).toList(),
      'business': business.toJson(),
      'documents': documents.map((d) => d.toJson()).toList(),
      'rating': rating,
      'total_reviews': totalReviews,
    };
  }
}
