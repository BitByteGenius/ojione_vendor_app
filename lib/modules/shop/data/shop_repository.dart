import '../../../core/network/api_response.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/shop_analytics_model.dart';
import 'mock_shop_data_source.dart';
import 'shop_data_source.dart';

class ShopRepository {
  final ShopDataSource _dataSource;

  ShopRepository({ShopDataSource? dataSource})
      : _dataSource = dataSource ?? MockShopDataSource();

  Future<ApiResponse<ShopDashboardAnalytics>> getShopAnalytics() {
    return _dataSource.getShopAnalytics();
  }

  Future<ApiResponse<List<ProductModel>>> getProducts() {
    return _dataSource.getProducts();
  }

  Future<ApiResponse<List<ShopOrderModel>>> getOrders() {
    return _dataSource.getOrders();
  }

  Future<ApiResponse<bool>> createProduct(Map<String, dynamic> data) {
    return _dataSource.createProduct(data);
  }
}
