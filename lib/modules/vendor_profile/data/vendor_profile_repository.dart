import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/business_model.dart';
import '../models/vendor_document_model.dart';
import '../models/vendor_profile_model.dart';

class VendorProfileRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<VendorProfileModel>> getProfile() async {
    // API ready:
    // final response = await _apiClient.get(ApiEndpoints.vendorProfile);
    // return ApiResponse.fromJson(response.data, (json) => VendorProfileModel.fromJson(json));

    await Future.delayed(const Duration(milliseconds: 400));
    final mock = VendorProfileModel(
      id: 'VEN-2024-001',
      businessName: 'Assam Heritage & Hospitality Group',
      ownerName: 'Gunajit Sharma',
      email: 'vendor@sewasetu.com',
      phone: '+91 98765 43210',
      alternatePhone: '+91 98765 01234',
      profileImageUrl: '',
      verificationStatus: 'verified',
      assignedServices: [
        ServiceType.stay,
        ServiceType.trips,
        ServiceType.shop,
        ServiceType.rental,
        ServiceType.localExperiences,
      ],
      business: BusinessModel(
        registrationNumber: 'AS-REG-2021-9988',
        gstin: '18AABCA1234F1Z5',
        panNumber: 'AABCA1234F',
        businessType: 'Private Limited Company',
        registeredAddress: 'House 42, GS Road, Christian Basti',
        city: 'Guwahati',
        state: 'Assam',
        pincode: '781005',
        bankName: 'State Bank of India',
        accountNumber: '••••••••8901',
        ifscCode: 'SBIN0000088',
        accountHolderName: 'Assam Heritage & Hospitality Group Pvt Ltd',
      ),
      documents: [
        VendorDocumentModel(
          id: 'DOC-01',
          documentType: 'GST Registration Certificate',
          documentNumber: '18AABCA1234F1Z5',
          documentUrl: 'https://docs.sewasetu.com/gst.pdf',
          verificationStatus: 'verified',
          uploadedAt: DateTime(2025, 5, 10),
        ),
        VendorDocumentModel(
          id: 'DOC-02',
          documentType: 'PAN Card',
          documentNumber: 'AABCA1234F',
          documentUrl: 'https://docs.sewasetu.com/pan.pdf',
          verificationStatus: 'verified',
          uploadedAt: DateTime(2025, 5, 10),
        ),
        VendorDocumentModel(
          id: 'DOC-03',
          documentType: 'Trade License / Tourism Permit',
          documentNumber: 'TL-GH-2024-554',
          documentUrl: 'https://docs.sewasetu.com/license.pdf',
          verificationStatus: 'verified',
          uploadedAt: DateTime(2025, 5, 12),
        ),
      ],
      rating: 4.8,
      totalReviews: 96,
    );

    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<bool>> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success(data: true, message: 'Profile updated successfully');
  }
}
