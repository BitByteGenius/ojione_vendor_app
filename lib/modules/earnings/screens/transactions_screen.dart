import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_status_chip.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/earnings_controller.dart';

class TransactionsScreen extends GetView<EarningsController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Transactions & Commission Audit',
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Full Transaction Log',
            subtitle: 'Real-time calculation of platform commission and net credit per order',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.transactions.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final tx = controller.transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: tx.serviceType.bgColor,
                        child: Icon(tx.serviceType.icon, color: tx.serviceType.color, size: 20),
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${tx.transactionId} • ${tx.bookingReference}', style: AppTextStyles.h4),
                            const SizedBox(height: 2),
                            Text(
                              'Service: ${tx.serviceType.displayName} • Date: ${Formatters.date(tx.createdAt)}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Gross: ${Formatters.currency(tx.grossAmount)}', style: AppTextStyles.caption),
                          Text('Fee: -${Formatters.currency(tx.commissionAmount)} (${tx.commissionRate}%)', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                          const SizedBox(height: 2),
                          Text('Net: ${Formatters.currency(tx.netAmount)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),
                      AppStatusChip(status: tx.status),
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
