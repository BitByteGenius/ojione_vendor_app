class ProductVariantModel {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int stockQuantity;

  ProductVariantModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stockQuantity,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'stock_quantity': stockQuantity,
    };
  }
}
