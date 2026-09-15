class EarningSummaryModel {
  final double totalGrossRevenue;
  final double totalCommission;
  final double netEarnings;
  final double availablePayoutBalance;
  final double pendingPayoutBalance;
  final double totalWithdrawn;

  EarningSummaryModel({
    required this.totalGrossRevenue,
    required this.totalCommission,
    required this.netEarnings,
    required this.availablePayoutBalance,
    required this.pendingPayoutBalance,
    required this.totalWithdrawn,
  });

  factory EarningSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningSummaryModel(
      totalGrossRevenue: (json['total_gross_revenue'] ?? 0).toDouble(),
      totalCommission: (json['total_commission'] ?? 0).toDouble(),
      netEarnings: (json['net_earnings'] ?? 0).toDouble(),
      availablePayoutBalance: (json['available_payout_balance'] ?? 0).toDouble(),
      pendingPayoutBalance: (json['pending_payout_balance'] ?? 0).toDouble(),
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
    );
  }
}
