import '../../../shared/enums/service_type.dart';

class TransactionModel {
  final String id;
  final String transactionId;
  final String bookingReference;
  final ServiceType serviceType;
  final double grossAmount;
  final double commissionRate; // dynamic percentage
  final double commissionAmount;
  final double netAmount;
  final String type; // 'credit', 'debit', 'payout'
  final String status; // 'settled', 'pending', 'refunded'
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.transactionId,
    required this.bookingReference,
    required this.serviceType,
    required this.grossAmount,
    required this.commissionRate,
    required this.commissionAmount,
    required this.netAmount,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      bookingReference: json['booking_reference'] ?? '',
      serviceType: ServiceType.fromString(json['service_type'] ?? 'stay'),
      grossAmount: (json['gross_amount'] ?? 0).toDouble(),
      commissionRate: (json['commission_rate'] ?? 0).toDouble(),
      commissionAmount: (json['commission_amount'] ?? 0).toDouble(),
      netAmount: (json['net_amount'] ?? 0).toDouble(),
      type: json['type'] ?? 'credit',
      status: json['status'] ?? 'settled',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
