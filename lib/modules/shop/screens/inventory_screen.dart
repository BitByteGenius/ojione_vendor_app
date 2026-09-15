import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/shop_controller.dart';

class InventoryScreen extends GetView<ShopController> {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Product Inventory & Stock Tracking',
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: AppCard(
            title: 'Stock Counts',
            subtitle: 'Monitor stock levels to avoid overselling on the marketplace',
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.products.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final p = controller.products[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.inventory_rounded, color: Colors.blueGrey),
                  title: Text(p.name, style: AppTextStyles.h4),
                  subtitle: Text('Category: ${p.category} • State: ${p.originState}', style: AppTextStyles.caption),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${p.stockQuantity} in stock', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: AppDimensions.spaceMd),
                      AppStatusChip(status: p.stockQuantity > 5 ? 'active' : 'low_stock'),
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
