import 'product_variant_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String originState; // Dynamic: Assam, Bihar, Meghalaya, etc.
  final String category;
  final double basePrice;
  final int stockQuantity;
  final String status; // 'active', 'low_stock', 'out_of_stock', 'draft'
  final List<ProductVariantModel> variants;
  final double rating;
  final int salesCount;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.originState,
    required this.category,
    required this.basePrice,
    required this.stockQuantity,
    required this.status,
    this.variants = const [],
    this.rating = 4.8,
    this.salesCount = 0,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      originState: json['origin_state'] ?? json['originState'] ?? '',
      category: json['category'] ?? 'Handicrafts',
      basePrice: (json['base_price'] ?? json['basePrice'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? json['stockQuantity'] ?? 0,
      status: json['status'] ?? 'active',
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((v) => ProductVariantModel.fromJson(v))
          .toList(),
      rating: (json['rating'] ?? 4.8).toDouble(),
      salesCount: json['sales_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'origin_state': originState,
      'category': category,
      'base_price': basePrice,
      'stock_quantity': stockQuantity,
      'status': status,
      'variants': variants.map((v) => v.toJson()).toList(),
      'rating': rating,
      'sales_count': salesCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
