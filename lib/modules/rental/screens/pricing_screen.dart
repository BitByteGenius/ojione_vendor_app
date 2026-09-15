import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/rental_controller.dart';

class RentalPricingScreen extends GetView<RentalController> {
  const RentalPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Rental Fleet Tariffs & Pricing',
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Daily Rates & Security Deposits',
            subtitle: 'City-wise tariffs and refundable deposit requirements',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.vehicles.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final v = controller.vehicles[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.currency_rupee_rounded, color: Colors.green),
                  title: Text(v.displayName, style: AppTextStyles.h4),
                  subtitle: Text('Operating City: ${v.operatingCity}', style: AppTextStyles.caption),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${Formatters.currency(v.pricePerDay)} / day', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Deposit: ${Formatters.currency(v.securityDeposit)}', style: AppTextStyles.caption),
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
