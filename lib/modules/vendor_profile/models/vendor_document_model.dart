class VendorDocumentModel {
  final String id;
  final String documentType;
  final String documentNumber;
  final String documentUrl;
  final String verificationStatus; // 'verified', 'pending', 'rejected'
  final String? rejectionReason;
  final DateTime uploadedAt;

  VendorDocumentModel({
    required this.id,
    required this.documentType,
    required this.documentNumber,
    required this.documentUrl,
    required this.verificationStatus,
    this.rejectionReason,
    required this.uploadedAt,
  });

  factory VendorDocumentModel.fromJson(Map<String, dynamic> json) {
    return VendorDocumentModel(
      id: json['id'] ?? '',
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'] ?? '',
      documentUrl: json['document_url'] ?? '',
      verificationStatus: json['verification_status'] ?? 'pending',
      rejectionReason: json['rejection_reason'],
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'document_number': documentNumber,
      'document_url': documentUrl,
      'verification_status': verificationStatus,
      'rejection_reason': rejectionReason,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
