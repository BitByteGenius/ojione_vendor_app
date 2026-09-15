import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class AppStatusChip extends StatelessWidget {
  final String status;
  final Color? customColor;
  final Color? customBgColor;

  const AppStatusChip({
    super.key,
    required this.status,
    this.customColor,
    this.customBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor) = _resolveColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm + 2,
        vertical: AppDimensions.space2xs + 2,
      ),
      decoration: BoxDecoration(
        color: customBgColor ?? bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: (customColor ?? textColor).withAlpha(60),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: customColor ?? textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  (Color, Color) _resolveColors(String s) {
    switch (s.toLowerCase()) {
      case 'active':
      case 'confirmed':
      case 'completed':
      case 'published':
      case 'verified':
      case 'available':
      case 'paid':
        return (AppColors.success, AppColors.successLight);

      case 'pending':
      case 'in_review':
      case 'processing':
      case 'submitted':
        return (AppColors.warning, AppColors.warningLight);

      case 'cancelled':
      case 'rejected':
      case 'failed':
      case 'unavailable':
        return (AppColors.error, AppColors.errorLight);

      case 'draft':
      case 'inactive':
      default:
        return (AppColors.lightTextSecondary, const Color(0xFFF1F5F9));
    }
  }
}
