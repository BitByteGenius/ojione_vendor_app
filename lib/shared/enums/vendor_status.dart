import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum VendorStatus {
  pending,
  approved,
  rejected,
  suspended;

  String get label {
    switch (this) {
      case VendorStatus.pending:
        return 'Pending Approval';
      case VendorStatus.approved:
        return 'Active / Approved';
      case VendorStatus.rejected:
        return 'Rejected';
      case VendorStatus.suspended:
        return 'Suspended';
    }
  }

  Color get color {
    switch (this) {
      case VendorStatus.pending:
        return AppColors.warning;
      case VendorStatus.approved:
        return AppColors.success;
      case VendorStatus.rejected:
        return AppColors.error;
      case VendorStatus.suspended:
        return Colors.grey;
    }
  }

  Color get bgColor {
    switch (this) {
      case VendorStatus.pending:
        return AppColors.warningLight;
      case VendorStatus.approved:
        return AppColors.successLight;
      case VendorStatus.rejected:
        return AppColors.errorLight;
      case VendorStatus.suspended:
        return const Color(0xFFF1F5F9);
    }
  }

  static VendorStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'approved':
      case 'active':
        return VendorStatus.approved;
      case 'rejected':
        return VendorStatus.rejected;
      case 'suspended':
        return VendorStatus.suspended;
      case 'pending':
      default:
        return VendorStatus.pending;
    }
  }
}

enum VendorVerificationStatus {
  unverified,
  pendingReview,
  verified,
  rejected;

  String get label {
    switch (this) {
      case VendorVerificationStatus.unverified:
        return 'Unverified';
      case VendorVerificationStatus.pendingReview:
        return 'KYC Under Review';
      case VendorVerificationStatus.verified:
        return 'KYC Verified';
      case VendorVerificationStatus.rejected:
        return 'KYC Rejected';
    }
  }

  Color get color {
    switch (this) {
      case VendorVerificationStatus.unverified:
        return Colors.grey;
      case VendorVerificationStatus.pendingReview:
        return AppColors.warning;
      case VendorVerificationStatus.verified:
        return AppColors.success;
      case VendorVerificationStatus.rejected:
        return AppColors.error;
    }
  }

  static VendorVerificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verified':
        return VendorVerificationStatus.verified;
      case 'pending':
      case 'pendingreview':
      case 'under_review':
        return VendorVerificationStatus.pendingReview;
      case 'rejected':
        return VendorVerificationStatus.rejected;
      case 'unverified':
      default:
        return VendorVerificationStatus.unverified;
    }
  }
}
