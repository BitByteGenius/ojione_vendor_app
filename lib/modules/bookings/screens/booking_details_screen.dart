import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/bookings_controller.dart';
import '../models/booking_status_model.dart';

class BookingDetailsScreen extends GetView<BookingsController> {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final b = controller.selectedBooking.value;

    if (b == null) {
      return MainLayout(
        title: 'Booking Details',
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No booking selected'),
              const SizedBox(height: AppDimensions.spaceMd),
              AppButton(text: 'Back to Bookings', onPressed: () => Get.back()),
            ],
          ),
        ),
      );
    }

    return MainLayout(
      title: 'Booking Details: ${b.bookingReference}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Action Header
            AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceMd),
                    decoration: BoxDecoration(
                      color: b.serviceType.bgColor,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(b.serviceType.icon, color: b.serviceType.color, size: 28),
                  ),
                  const SizedBox(width: AppDimensions.spaceLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.itemName, style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Text(
                          'Reference: ${b.bookingReference} • Service: ${b.serviceType.displayName}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  AppStatusChip(status: b.status.name),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Customer Details and Reservation Duration
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppCard(
                    title: 'Customer Information',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _info('Full Name', b.customerName),
                        _info('Email', b.customerEmail),
                        _info('Mobile Phone', b.customerPhone),
                        _info('Guests / Units', '${b.guestsOrUnits}'),
                        if (b.specialRequests != null) _info('Special Notes', b.specialRequests!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceLg),
                Expanded(
                  child: AppCard(
                    title: 'Financial Breakdown',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _info('Total Booking Value', Formatters.currency(b.totalAmount)),
                        _info('SewaSetu Platform Commission', '- ${Formatters.currency(b.commissionAmount)}'),
                        const Divider(),
                        _info('Net Vendor Payout', Formatters.currency(b.vendorEarnings), isHighlight: true),
                        _info('Payment Mode / Status', b.paymentStatus),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spaceXl),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (b.status == BookingStatus.pending) ...[
                  AppButton(
                    text: 'Decline Booking',
                    type: AppButtonType.danger,
                    onPressed: () => controller.updateStatus(b.id, BookingStatus.cancelled),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  AppButton(
                    text: 'Confirm Booking',
                    type: AppButtonType.primary,
                    onPressed: () => controller.updateStatus(b.id, BookingStatus.confirmed),
                  ),
                ],
                if (b.status == BookingStatus.confirmed) ...[
                  AppButton(
                    text: 'Mark In-Progress / Checked In',
                    type: AppButtonType.primary,
                    onPressed: () => controller.updateStatus(b.id, BookingStatus.checkedIn),
                  ),
                ],
                if (b.status == BookingStatus.checkedIn) ...[
                  AppButton(
                    text: 'Complete Booking',
                    type: AppButtonType.primary,
                    onPressed: () => controller.updateStatus(b.id, BookingStatus.completed),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(
            value,
            style: isHighlight
                ? AppTextStyles.h4.copyWith(color: AppColors.primary)
                : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
