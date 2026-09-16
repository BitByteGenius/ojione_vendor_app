import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ListingStatus {
  draft,
  pendingApproval,
  approved,
  rejected,
  suspended,
  archived;

  String get label {
    switch (this) {
      case ListingStatus.draft:
        return 'Draft';
      case ListingStatus.pendingApproval:
        return 'Pending Approval';
      case ListingStatus.approved:
        return 'Live / Approved';
      case ListingStatus.rejected:
        return 'Rejected';
      case ListingStatus.suspended:
        return 'Suspended';
      case ListingStatus.archived:
        return 'Archived';
    }
  }

  Color get color {
    switch (this) {
      case ListingStatus.draft:
        return const Color(0xFF64748B);
      case ListingStatus.pendingApproval:
        return AppColors.warning;
      case ListingStatus.approved:
        return AppColors.success;
      case ListingStatus.rejected:
        return AppColors.error;
      case ListingStatus.suspended:
        return const Color(0xFFB45309);
      case ListingStatus.archived:
        return const Color(0xFF94A3B8);
    }
  }

  Color get bgColor {
    switch (this) {
      case ListingStatus.draft:
        return const Color(0xFFF1F5F9);
      case ListingStatus.pendingApproval:
        return AppColors.warningLight;
      case ListingStatus.approved:
        return AppColors.successLight;
      case ListingStatus.rejected:
        return AppColors.errorLight;
      case ListingStatus.suspended:
        return const Color(0xFFFEF3C7);
      case ListingStatus.archived:
        return const Color(0xFFF8FAFC);
    }
  }

  static ListingStatus fromString(String value) {
    switch (value.toLowerCase().replaceAll('_', '').replaceAll(' ', '')) {
      case 'published':
      case 'approved':
      case 'live':
      case 'active':
        return ListingStatus.approved;
      case 'pending':
      case 'pendingapproval':
      case 'underreview':
        return ListingStatus.pendingApproval;
      case 'rejected':
        return ListingStatus.rejected;
      case 'suspended':
        return ListingStatus.suspended;
      case 'archived':
        return ListingStatus.archived;
      case 'draft':
      default:
        return ListingStatus.draft;
    }
  }
}
