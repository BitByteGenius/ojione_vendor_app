import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class ShopRepository {
  final ApiClient apiClient = ApiClient.instance;

  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mock = [
      ProductModel(
        id: 'prd-001',
        name: 'Assam Authentic Bell Metal Kahi-Bati Set',
        description: 'Traditional handcrafted brass & bell metal dining utensils forged by Sarthebari artisans.',
        originState: 'Assam',
        category: 'Handicrafts & Bell Metal',
        basePrice: 3800,
        stockQuantity: 24,
        status: 'active',
        salesCount: 86,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      ProductModel(
        id: 'prd-002',
        name: 'Handwoven Muga Silk Mekhela Sador with Traditional Motifs',
        description: 'Golden Muga silk traditional attire handwoven in Sualkuchi, the Manchester of Assam.',
        originState: 'Assam',
        category: 'Handloom & Textiles',
        basePrice: 18500,
        stockQuantity: 6,
        status: 'active',
        salesCount: 32,
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
      ProductModel(
        id: 'prd-003',
        name: 'Original Handpainted Madhubani Canvas Painting',
        description: 'Folk art depicting Tree of Life created with natural dyes and nib pens by Mithila artisans.',
        originState: 'Bihar',
        category: 'Traditional Art & Paintings',
        basePrice: 2400,
        stockQuantity: 15,
        status: 'active',
        salesCount: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      ProductModel(
        id: 'prd-004',
        name: 'Premium Organic Phool Makhana (Fox Nuts)',
        description: 'Naturally harvested GI-tagged Mithila Makhana processed with traditional roasting methods.',
        originState: 'Bihar',
        category: 'Indigenous Organic Foods',
        basePrice: 450,
        stockQuantity: 120,
        status: 'active',
        salesCount: 310,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<List<ShopOrderModel>>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mock = [
      ShopOrderModel(
        id: 'ord-101',
        orderNumber: 'ORD-2026-9901',
        productName: 'Assam Bell Metal Kahi-Bati Set',
        customerName: 'Sunita Sharma',
        shippingAddress: 'Flat 4B, Silver Heights, Salt Lake, Kolkata',
        quantity: 1,
        totalPrice: 3800,
        status: 'processing',
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ShopOrderModel(
        id: 'ord-102',
        orderNumber: 'ORD-2026-9902',
        productName: 'Organic Phool Makhana (Pack of 3)',
        customerName: 'Vikram Mehta',
        shippingAddress: 'Plot 12, Indiranagar, Bengaluru',
        quantity: 3,
        totalPrice: 1350,
        status: 'shipped',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    return ApiResponse.success(data: mock);
  }

  Future<ApiResponse<bool>> createProduct(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Product added successfully');
  }
}
