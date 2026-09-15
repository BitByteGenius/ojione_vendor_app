class PayoutModel {
  final String id;
  final String payoutReference;
  final double amount;
  final String bankName;
  final String accountNumber;
  final String utrNumber;
  final String status; // 'completed', 'processing', 'failed'
  final DateTime requestedAt;
  final DateTime? processedAt;

  PayoutModel({
    required this.id,
    required this.payoutReference,
    required this.amount,
    required this.bankName,
    required this.accountNumber,
    required this.utrNumber,
    required this.status,
    required this.requestedAt,
    this.processedAt,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'] ?? '',
      payoutReference: json['payout_reference'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      bankName: json['bank_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      utrNumber: json['utr_number'] ?? '',
      status: json['status'] ?? 'completed',
      requestedAt: json['requested_at'] != null ? DateTime.parse(json['requested_at']) : DateTime.now(),
      processedAt: json['processed_at'] != null ? DateTime.parse(json['processed_at']) : null,
    );
  }
}
