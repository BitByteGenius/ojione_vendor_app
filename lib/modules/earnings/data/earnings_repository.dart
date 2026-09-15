import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../../shared/enums/service_type.dart';
import '../models/earning_model.dart';
import '../models/payout_model.dart';
import '../models/transaction_model.dart';

class EarningsRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<EarningSummaryModel>> getSummary() async {
    // API client call ready:
    // final response = await _apiClient.get(ApiEndpoints.earnings);
    // return ApiResponse.fromJson(response.data, (json) => EarningSummaryModel.fromJson(json));

    await Future.delayed(const Duration(milliseconds: 300));
    final mockSummary = EarningSummaryModel(
      totalGrossRevenue: 485000,
      totalCommission: 48500,
      netEarnings: 436500,
      availablePayoutBalance: 68400,
      pendingPayoutBalance: 24500,
      totalWithdrawn: 343600,
    );
    return ApiResponse.success(data: mockSummary);
  }

  Future<ApiResponse<List<TransactionModel>>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mockTransactions = [
      TransactionModel(
        id: '1',
        transactionId: 'TXN-90812',
        bookingReference: 'BK-2026-1049',
        serviceType: ServiceType.stay,
        grossAmount: 8500,
        commissionRate: 10.0,
        commissionAmount: 850,
        netAmount: 7650,
        type: 'credit',
        status: 'settled',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      TransactionModel(
        id: '2',
        transactionId: 'TXN-90811',
        bookingReference: 'BK-2026-1048',
        serviceType: ServiceType.localExperiences,
        grossAmount: 2400,
        commissionRate: 10.0,
        commissionAmount: 240,
        netAmount: 2160,
        type: 'credit',
        status: 'settled',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      TransactionModel(
        id: '3',
        transactionId: 'TXN-90810',
        bookingReference: 'BK-2026-1047',
        serviceType: ServiceType.rental,
        grossAmount: 5600,
        commissionRate: 10.0,
        commissionAmount: 560,
        netAmount: 5040,
        type: 'credit',
        status: 'settled',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    return ApiResponse.success(data: mockTransactions);
  }

  Future<ApiResponse<List<PayoutModel>>> getPayouts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mockPayouts = [
      PayoutModel(
        id: '1',
        payoutReference: 'PO-2026-0045',
        amount: 45000,
        bankName: 'State Bank of India',
        accountNumber: '••••••••8901',
        utrNumber: 'UTR2026091000123',
        status: 'completed',
        requestedAt: DateTime(2026, 9, 10),
        processedAt: DateTime(2026, 9, 11),
      ),
      PayoutModel(
        id: '2',
        payoutReference: 'PO-2026-0044',
        amount: 82000,
        bankName: 'State Bank of India',
        accountNumber: '••••••••8901',
        utrNumber: 'UTR2026090100456',
        status: 'completed',
        requestedAt: DateTime(2026, 9, 1),
        processedAt: DateTime(2026, 9, 2),
      ),
    ];
    return ApiResponse.success(data: mockPayouts);
  }

  Future<ApiResponse<bool>> requestPayout(double amount) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse.success(data: true, message: 'Payout request of ₹$amount submitted successfully');
  }
}
