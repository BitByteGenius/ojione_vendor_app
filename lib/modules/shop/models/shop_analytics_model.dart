import '../../../shared/widgets/charts/chart_data_models.dart';
import 'order_model.dart';

class CategorySalesModel {
  final String categoryName;
  final int productsCount;
  final int ordersCount;
  final double revenue;

  const CategorySalesModel({
    required this.categoryName,
    required this.productsCount,
    required this.ordersCount,
    required this.revenue,
  });
}

class ShopDashboardAnalytics {
  final int totalProducts;
  final int activeProducts;
  final int outOfStock;
  final int lowStock;
  final int totalOrders;
  final int todayOrders;
  final double totalRevenue;
  final double pendingPayouts;
  final List<ChartDataPoint> salesOverview;
  final List<BarGroupDataModel> orderTrends;
  final List<PieSliceDataModel> orderStatusBreakdown;
  final List<CategorySalesModel> categoryPerformances;
  final List<ShopOrderModel> recentOrders;

  const ShopDashboardAnalytics({
    required this.totalProducts,
    required this.activeProducts,
    required this.outOfStock,
    required this.lowStock,
    required this.totalOrders,
    required this.todayOrders,
    required this.totalRevenue,
    required this.pendingPayouts,
    required this.salesOverview,
    required this.orderTrends,
    required this.orderStatusBreakdown,
    required this.categoryPerformances,
    required this.recentOrders,
  });
}
