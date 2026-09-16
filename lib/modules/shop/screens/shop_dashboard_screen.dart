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
import '../../../../shared/widgets/charts/app_bar_chart.dart';
import '../../../../shared/widgets/charts/app_donut_chart.dart';
import '../../../../shared/widgets/charts/app_kpi_card.dart';
import '../../../../shared/widgets/charts/app_line_chart.dart';
import '../../../../shared/widgets/main_layout.dart';
import '../controllers/shop_controller.dart';
import '../models/order_model.dart';
import '../models/shop_analytics_model.dart';

class ShopDashboardScreen extends GetView<ShopController> {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Shop & Marketplace Vendor Portal',
      trailingHeader: AppButton(
        text: '+ Add Product',
        icon: Icons.add_rounded,
        height: AppDimensions.buttonHeightSm,
        onPressed: () => Get.toNamed('/shop/products/add'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.analytics.value == null) {
          return const AppLoader(message: 'Loading Shop analytics & inventory...');
        }

        final a = controller.analytics.value;

        return RefreshIndicator(
          onRefresh: () async => controller.loadShopData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-navigation bar
                _buildSubNav(),
                const SizedBox(height: AppDimensions.spaceLg),

                // Top KPI Metrics Grid (8 Core Shop Metrics)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 1100;
                    final isMedium = constraints.maxWidth > 700;
                    final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppDimensions.spaceMd,
                      mainAxisSpacing: AppDimensions.spaceMd,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.6 : (isMedium ? 1.8 : 2.2),
                      children: [
                        AppKpiCard(
                          title: 'Total Products',
                          value: '${a?.totalProducts ?? 0}',
                          subtitle: '${a?.activeProducts ?? 0} Live in Store',
                          icon: Icons.storefront_rounded,
                          color: AppColors.shopService,
                          trendBadge: 'Catalog',
                          onTap: () => Get.toNamed('/shop/products'),
                        ),
                        AppKpiCard(
                          title: 'Inventory Alerts',
                          value: '${(a?.lowStock ?? 0) + (a?.outOfStock ?? 0)} Alerts',
                          subtitle: '${a?.lowStock ?? 0} Low Stock • ${a?.outOfStock ?? 0} Out',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.warning,
                          trendBadge: 'Action Req',
                          isPositiveTrend: false,
                          onTap: () => Get.toNamed('/shop/inventory'),
                        ),
                        AppKpiCard(
                          title: "Today's Orders",
                          value: '${a?.todayOrders ?? 0}',
                          subtitle: 'Total orders: ${a?.totalOrders ?? 0}',
                          icon: Icons.shopping_bag_outlined,
                          color: AppColors.primary,
                          trendBadge: '+14.5%',
                          onTap: () => Get.toNamed('/shop/orders'),
                        ),
                        AppKpiCard(
                          title: 'Shop Sales Revenue',
                          value: Formatters.currency(a?.totalRevenue ?? 0),
                          subtitle: 'Pending payout: ${Formatters.currency(a?.pendingPayouts ?? 0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.secondary,
                          trendBadge: '+19.2%',
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Charts Section: Sales Overview Line Chart & Order Status Donut Chart
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 950;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: AppCard(
                              title: 'Monthly Sales Revenue Overview',
                              subtitle: 'Net product sales trend (INR)',
                              child: AppLineChart(
                                dataPoints: a?.salesOverview ?? [],
                                primaryColor: AppColors.shopService,
                                valueFormatter: (v) => Formatters.currency(v),
                                height: 260,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            flex: 4,
                            child: AppCard(
                              title: 'Order Status Distribution',
                              subtitle: 'Fulfillment and delivery breakdown',
                              child: AppDonutChart(
                                slices: a?.orderStatusBreakdown ?? [],
                                centerLabel: 'Orders',
                                centerValue: '${a?.totalOrders ?? 0}',
                                height: 260,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          AppCard(
                            title: 'Monthly Sales Revenue Overview',
                            subtitle: 'Net product sales trend (INR)',
                            child: AppLineChart(
                              dataPoints: a?.salesOverview ?? [],
                              primaryColor: AppColors.shopService,
                              valueFormatter: (v) => Formatters.currency(v),
                              height: 240,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceLg),
                          AppCard(
                            title: 'Order Status Distribution',
                            subtitle: 'Fulfillment and delivery breakdown',
                            child: AppDonutChart(
                              slices: a?.orderStatusBreakdown ?? [],
                              centerLabel: 'Orders',
                              centerValue: '${a?.totalOrders ?? 0}',
                              height: 240,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Daily Order Volume Bar Chart
                AppCard(
                  title: 'Daily Order Volume (Past 7 Days)',
                  subtitle: 'Units ordered per day of week',
                  child: AppBarChart(
                    groups: a?.orderTrends ?? [],
                    barColor: AppColors.shopService,
                    height: 220,
                  ),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Recent Orders Table
                AppCard(
                  title: 'Recent Marketplace Orders',
                  subtitle: 'Latest customer purchases awaiting dispatch or delivered',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/shop/orders'),
                    child: const Text('View All Orders'),
                  ),
                  child: _buildRecentOrdersTable(a?.recentOrders ?? []),
                ),

                const SizedBox(height: AppDimensions.spaceLg),

                // Category Performance Section
                AppCard(
                  title: 'Category Sales Performance',
                  subtitle: 'Revenue generated and order volume by craft category',
                  child: _buildCategoryPerformanceList(a?.categoryPerformances ?? []),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubNav() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.shopService),
            label: const Text('Products Catalog'),
            onPressed: () => Get.toNamed('/shop/products'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.shelves, size: 16, color: AppColors.shopService),
            label: const Text('Inventory & Stock'),
            onPressed: () => Get.toNamed('/shop/inventory'),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          ActionChip(
            avatar: const Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.shopService),
            label: const Text('Customer Orders'),
            onPressed: () => Get.toNamed('/shop/orders'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersTable(List<ShopOrderModel> orders) {
    if (orders.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No orders recorded.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('ORDER #', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ],
        rows: orders.map((o) {
          return DataRow(
            cells: [
              DataCell(Text(o.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(o.customerName)),
              DataCell(Text(o.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5))),
              DataCell(Text('× ${o.quantity}')),
              DataCell(Text(Formatters.currency(o.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(AppStatusChip(status: o.status)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryPerformanceList(List<CategorySalesModel> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final c = list[index];
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.shopServiceBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.storefront_rounded, color: AppColors.shopService, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.categoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text('${c.productsCount} Products listed • ${c.ordersCount} Units fulfilled', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              Formatters.currency(c.revenue),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.shopService),
            ),
          ],
        );
      },
    );
  }
}
