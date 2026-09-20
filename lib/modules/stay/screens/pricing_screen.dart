import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/stay_controller.dart';

class StayPricingScreen extends GetView<StayController> {
  const StayPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Stay Dynamic Pricing & Rules',
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoader();

        final pr = controller.pricing.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                title: 'Seasonal & Weekend Rate Rules',
                subtitle: 'Configure automated pricing multipliers for weekends and peak dates',
                child: Column(
                  children: [
                    _rateRow('Weekday Base Tariff', Formatters.currency(pr?.weekdayBasePrice ?? 0)),
                    _rateRow('Weekend Base Tariff (Fri-Sat)', Formatters.currency(pr?.weekendBasePrice ?? 0)),
                    _rateRow('Extra Adult Guest Charge', Formatters.currency(pr?.extraAdultPrice ?? 0)),
                    _rateRow('Cleaning Fee', Formatters.currency(pr?.cleaningFee ?? 0)),
                    _rateRow('Weekly Stay Discount', '${pr?.discountWeekly ?? 10}%'),
                    _rateRow('Monthly Long-term Discount', '${pr?.discountMonthly ?? 25}%'),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Adjust Rates',
                  icon: Icons.tune_rounded,
                  onPressed: () {
                    Get.snackbar('Pricing', 'Rates adjustment dialog');
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _rateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
