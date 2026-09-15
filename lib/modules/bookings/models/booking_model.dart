import '../../../shared/enums/service_type.dart';
import 'booking_status_model.dart';

class BookingModel {
  final String id;
  final String bookingReference;
  final ServiceType serviceType;
  final String itemName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime startDate;
  final DateTime endDate;
  final int guestsOrUnits;
  final double totalAmount;
  final double commissionAmount;
  final double vendorEarnings;
  final BookingStatus status;
  final String paymentStatus;
  final String? specialRequests;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.bookingReference,
    required this.serviceType,
    required this.itemName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.startDate,
    required this.endDate,
    required this.guestsOrUnits,
    required this.totalAmount,
    required this.commissionAmount,
    required this.vendorEarnings,
    required this.status,
    required this.paymentStatus,
    this.specialRequests,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingReference: json['booking_reference'] ?? json['bookingReference'] ?? '',
      serviceType: ServiceType.fromString(json['service_type'] ?? 'stay'),
      itemName: json['item_name'] ?? json['itemName'] ?? '',
      customerName: json['customer_name'] ?? json['customerName'] ?? '',
      customerEmail: json['customer_email'] ?? json['customerEmail'] ?? '',
      customerPhone: json['customer_phone'] ?? json['customerPhone'] ?? '',
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : DateTime.now(),
      guestsOrUnits: json['guests_or_units'] ?? json['guestsOrUnits'] ?? 1,
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0).toDouble(),
      commissionAmount: (json['commission_amount'] ?? json['commissionAmount'] ?? 0).toDouble(),
      vendorEarnings: (json['vendor_earnings'] ?? json['vendorEarnings'] ?? 0).toDouble(),
      status: BookingStatus.fromString(json['status'] ?? 'pending'),
      paymentStatus: json['payment_status'] ?? 'paid',
      specialRequests: json['special_requests'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_reference': bookingReference,
      'service_type': serviceType.id,
      'item_name': itemName,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'guests_or_units': guestsOrUnits,
      'total_amount': totalAmount,
      'commission_amount': commissionAmount,
      'vendor_earnings': vendorEarnings,
      'status': status.name,
      'payment_status': paymentStatus,
      'special_requests': specialRequests,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
