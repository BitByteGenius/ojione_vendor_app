import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.primary;
      case BookingStatus.inProgress:
        return const Color(0xFF0284C7);
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  Color get bgColor {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.warningLight;
      case BookingStatus.confirmed:
        return AppColors.primaryLight;
      case BookingStatus.inProgress:
        return const Color(0xFFE0F2FE);
      case BookingStatus.completed:
        return AppColors.successLight;
      case BookingStatus.cancelled:
        return AppColors.errorLight;
    }
  }

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase().replaceAll('_', '').replaceAll(' ', '')) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'inprogress':
      case 'ongoing':
      case 'rented':
        return BookingStatus.inProgress;
      case 'completed':
      case 'delivered':
        return BookingStatus.completed;
      case 'cancelled':
      case 'rejected':
        return BookingStatus.cancelled;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }
}
