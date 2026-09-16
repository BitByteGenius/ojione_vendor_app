import 'package:flutter/material.dart';
import '../../../core/network/api_response.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/charts/chart_data_models.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/shop_analytics_model.dart';
import 'shop_data_source.dart';

class MockShopDataSource implements ShopDataSource {
  @override
  Future<ApiResponse<ShopDashboardAnalytics>> getShopAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final analytics = ShopDashboardAnalytics(
      totalProducts: 48,
      activeProducts: 42,
      outOfStock: 2,
      lowStock: 4,
      totalOrders: 326,
      todayOrders: 18,
      totalRevenue: 245800,
      pendingPayouts: 31200,
      salesOverview: const [
        ChartDataPoint(x: 0, y: 110000, label: 'Apr'),
        ChartDataPoint(x: 1, y: 145000, label: 'May'),
        ChartDataPoint(x: 2, y: 190000, label: 'Jun'),
        ChartDataPoint(x: 3, y: 175000, label: 'Jul'),
        ChartDataPoint(x: 4, y: 218000, label: 'Aug'),
        ChartDataPoint(x: 5, y: 245800, label: 'Sep'),
      ],
      orderTrends: const [
        BarGroupDataModel(x: 0, label: 'Mon', value: 14),
        BarGroupDataModel(x: 1, label: 'Tue', value: 22),
        BarGroupDataModel(x: 2, label: 'Wed', value: 18),
        BarGroupDataModel(x: 3, label: 'Thu', value: 27),
        BarGroupDataModel(x: 4, label: 'Fri', value: 38),
        BarGroupDataModel(x: 5, label: 'Sat', value: 46),
        BarGroupDataModel(x: 6, label: 'Sun', value: 31),
      ],
      orderStatusBreakdown: const [
        PieSliceDataModel(label: 'Delivered', value: 198, color: Color(0xFF10B981), displayValue: '198 (61%)'),
        PieSliceDataModel(label: 'Shipped', value: 68, color: Color(0xFF2563EB), displayValue: '68 (21%)'),
        PieSliceDataModel(label: 'Processing', value: 44, color: AppColors.shopService, displayValue: '44 (13%)'),
        PieSliceDataModel(label: 'Returned / Cancelled', value: 16, color: Color(0xFFEF4444), displayValue: '16 (5%)'),
      ],
      categoryPerformances: const [
        CategorySalesModel(
          categoryName: 'Handloom & Silk Textiles',
          productsCount: 16,
          ordersCount: 142,
          revenue: 148000,
        ),
        CategorySalesModel(
          categoryName: 'Bell Metal & Handicrafts',
          productsCount: 14,
          ordersCount: 96,
          revenue: 62000,
        ),
        CategorySalesModel(
          categoryName: 'Indigenous Organic Foods',
          productsCount: 12,
          ordersCount: 64,
          revenue: 26800,
        ),
        CategorySalesModel(
          categoryName: 'Traditional Art & Paintings',
          productsCount: 6,
          ordersCount: 24,
          revenue: 9000,
        ),
      ],
      recentOrders: [
        ShopOrderModel(
          id: 'ord-101',
          orderNumber: 'ORD-2026-9901',
          productName: 'Assam Bell Metal Kahi-Bati Set',
          customerName: 'Sunita Sharma',
          shippingAddress: 'Salt Lake, Kolkata, West Bengal',
          quantity: 2,
          totalPrice: 7600,
          status: 'processing',
          orderDate: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        ShopOrderModel(
          id: 'ord-102',
          orderNumber: 'ORD-2026-9902',
          productName: 'Muga Silk Mekhela Sador',
          customerName: 'Kalyani Phukan',
          shippingAddress: 'Uzanbazar, Guwahati, Assam',
          quantity: 1,
          totalPrice: 18500,
          status: 'shipped',
          orderDate: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        ShopOrderModel(
          id: 'ord-103',
          orderNumber: 'ORD-2026-9903',
          productName: 'Mithila Roasted Phool Makhana (Pack of 4)',
          customerName: 'Rohit Kulkarni',
          shippingAddress: 'Bandra West, Mumbai, Maharashtra',
          quantity: 4,
          totalPrice: 1800,
          status: 'delivered',
          orderDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ShopOrderModel(
          id: 'ord-104',
          orderNumber: 'ORD-2026-9904',
          productName: 'Handpainted Madhubani Canvas Painting',
          customerName: 'Pooja Nair',
          shippingAddress: 'Indiranagar, Bengaluru, Karnataka',
          quantity: 1,
          totalPrice: 2400,
          status: 'processing',
          orderDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );

    return ApiResponse.success(data: analytics);
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 250));
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
        stockQuantity: 4, // low stock
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

  @override
  Future<ApiResponse<List<ShopOrderModel>>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 250));
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

  @override
  Future<ApiResponse<bool>> createProduct(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(data: true, message: 'Product added successfully');
  }
}
