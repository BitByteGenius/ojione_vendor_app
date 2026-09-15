import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/earnings_controller.dart';

class EarningsScreen extends GetView<EarningsController> {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Earnings & Payouts',
      trailingHeader: AppButton(
        text: 'Request Payout',
        icon: Icons.payments_outlined,
        height: AppDimensions.buttonHeightSm,
        onPressed: () {
          final balance = controller.summary.value?.availablePayoutBalance ?? 0;
          if (balance <= 0) {
            Get.snackbar('Notice', 'No available balance to withdraw at this time');
            return;
          }
          controller.requestPayout(balance);
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.summary.value == null) {
          return const AppLoader(message: 'Loading financial summary...');
        }

        final s = controller.summary.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Financial KPI Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Row(
                    children: [
                      Expanded(
                        child: _financialCard(
                          title: 'Available Payout Balance',
                          amount: Formatters.currency(s?.availablePayoutBalance ?? 0),
                          subtitle: 'Ready for bank settlement',
                          color: AppColors.primary,
                          icon: Icons.account_balance_wallet_rounded,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),
                      Expanded(
                        child: _financialCard(
                          title: 'Net Vendor Earnings',
                          amount: Formatters.currency(s?.netEarnings ?? 0),
                          subtitle: 'After platform commissions',
                          color: AppColors.stayService,
                          icon: Icons.trending_up_rounded,
                        ),
                      ),
                      if (isWide) const SizedBox(width: AppDimensions.spaceMd),
                      if (isWide)
                        Expanded(
                          child: _financialCard(
                            title: 'Pending Settlements',
                            amount: Formatters.currency(s?.pendingPayoutBalance ?? 0),
                            subtitle: 'Under clearing period',
                            color: AppColors.warning,
                            icon: Icons.hourglass_empty_rounded,
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Navigation action tabs
              Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.receipt_long_outlined, size: 16),
                    label: const Text('View All Transactions'),
                    onPressed: () => Get.toNamed('/earnings/transactions'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.history_rounded, size: 16),
                    label: const Text('Payout Settlement History'),
                    onPressed: () => Get.toNamed('/earnings/payouts'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Recent Transactions Table
              AppCard(
                title: 'Recent Commission & Settlement Ledger',
                subtitle: 'Dynamic commission per service without hardcoded rates',
                trailing: TextButton(
                  onPressed: () => Get.toNamed('/earnings/transactions'),
                  child: const Text('See All'),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.transactions.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tx = controller.transactions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: tx.serviceType.bgColor,
                        child: Icon(tx.serviceType.icon, color: tx.serviceType.color, size: 18),
                      ),
                      title: Text('${tx.bookingReference} (${tx.serviceType.displayName})', style: AppTextStyles.h4),
                      subtitle: Text(
                        'Gross: ${Formatters.currency(tx.grossAmount)} • Platform Fee (${tx.commissionRate}%): -${Formatters.currency(tx.commissionAmount)}',
                        style: AppTextStyles.caption,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+ ${Formatters.currency(tx.netAmount)}',
                            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                          ),
                          AppStatusChip(status: tx.status),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _financialCard({
    required String title,
    required String amount,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(amount, style: AppTextStyles.h2.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
