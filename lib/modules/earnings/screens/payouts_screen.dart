import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/earnings_controller.dart';

class PayoutsScreen extends GetView<EarningsController> {
  const PayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Settlement & Payout History',
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Completed Bank Disbursements',
            subtitle: 'Direct NEFT/RTGS bank transfers processed into your verified account',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.payouts.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final po = controller.payouts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_rounded, color: Colors.teal, size: 24),
                      const SizedBox(width: AppDimensions.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${po.payoutReference} — ${po.bankName}', style: AppTextStyles.h4),
                            const SizedBox(height: 2),
                            Text(
                              'Account: ${po.accountNumber} • UTR: ${po.utrNumber} • Settled: ${Formatters.date(po.processedAt)}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.currency(po.amount),
                        style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),
                      AppStatusChip(status: po.status),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
