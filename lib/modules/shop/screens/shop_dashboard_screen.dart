import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/shop_controller.dart';

class ShopDashboardScreen extends GetView<ShopController> {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Indigenous Marketplace & Shop',
      trailingHeader: AppButton(
        text: '+ Add Product',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/shop/products/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const AppLoader(message: 'Loading shop catalog...');
        }

        final states = ['All States', ...controller.products.map((p) => p.originState).toSet()];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // State Filter Chips (Assam, Bihar, etc. - dynamically populated)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: states.map((st) {
                    final isSel = controller.selectedStateFilter.value == st;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
                      child: ChoiceChip(
                        label: Text(st),
                        selected: isSel,
                        selectedColor: AppColors.shopService,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => controller.selectedStateFilter.value = st,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Orders & Inventory Quick Actions
              Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.inventory_2_outlined, size: 16),
                    label: const Text('Inventory & Stocks'),
                    onPressed: () => Get.toNamed('/shop/inventory'),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  ActionChip(
                    avatar: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: Obx(() => Text('Orders (${controller.orders.length})')),
                    onPressed: () => Get.toNamed('/shop/orders'),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Products Grid
              AppCard(
                title: 'Native Cultural Products Catalog',
                subtitle: 'State-wise GI tagged and artisanal goods',
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final p = controller.filteredProducts[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.shopServiceBg,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: const Icon(Icons.storefront_rounded, color: AppColors.shopService, size: 24),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(p.name, style: AppTextStyles.h4)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              p.originState.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text('${p.category} • In Stock: ${p.stockQuantity} units • Sold: ${p.salesCount}', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(p.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Formatters.currency(p.basePrice), style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                          AppStatusChip(status: p.status),
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
}
