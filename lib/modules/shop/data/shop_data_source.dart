import '../../../core/network/api_response.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/shop_analytics_model.dart';

abstract class ShopDataSource {
  Future<ApiResponse<ShopDashboardAnalytics>> getShopAnalytics();
  Future<ApiResponse<List<ProductModel>>> getProducts();
  Future<ApiResponse<List<ShopOrderModel>>> getOrders();
  Future<ApiResponse<bool>> createProduct(Map<String, dynamic> data);
}
