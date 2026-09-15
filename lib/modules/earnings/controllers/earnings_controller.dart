import 'package:get/get.dart';
import '../data/earnings_repository.dart';
import '../models/earning_model.dart';
import '../models/payout_model.dart';
import '../models/transaction_model.dart';

class EarningsController extends GetxController {
  final EarningsRepository _repository = EarningsRepository();

  final isLoading = true.obs;
  final summary = Rxn<EarningSummaryModel>();
  final transactions = <TransactionModel>[].obs;
  final payouts = <PayoutModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFinancials();
  }

  Future<void> loadFinancials() async {
    try {
      isLoading.value = true;
      final sumRes = await _repository.getSummary();
      if (sumRes.success && sumRes.data != null) {
        summary.value = sumRes.data;
      }
      final txnRes = await _repository.getTransactions();
      if (txnRes.success && txnRes.data != null) {
        transactions.assignAll(txnRes.data!);
      }
      final poRes = await _repository.getPayouts();
      if (poRes.success && poRes.data != null) {
        payouts.assignAll(poRes.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load financial records');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestPayout(double amount) async {
    try {
      isLoading.value = true;
      final res = await _repository.requestPayout(amount);
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadFinancials();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit payout request');
    } finally {
      isLoading.value = false;
    }
  }
}
