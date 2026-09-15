import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/shop_controller.dart';

class ShopOrdersScreen extends GetView<ShopController> {
  const ShopOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Shop Product Orders',
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Customer Orders & Shipments',
            subtitle: 'Dispatch products and manage shipping tracking numbers',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.orders.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final ord = controller.orders[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEF3C7),
                    child: Icon(Icons.shopping_bag_outlined, color: Colors.amber, size: 20),
                  ),
                  title: Text('${ord.orderNumber} — ${ord.productName}', style: AppTextStyles.h4),
                  subtitle: Text(
                    'Customer: ${ord.customerName} • Qty: ${ord.quantity} • Deliver to: ${ord.shippingAddress}',
                    style: AppTextStyles.caption,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Formatters.currency(ord.totalPrice), style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                      AppStatusChip(status: ord.status),
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
