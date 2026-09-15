class ShopOrderModel {
  final String id;
  final String orderNumber;
  final String productName;
  final String customerName;
  final String shippingAddress;
  final int quantity;
  final double totalPrice;
  final String status; // 'processing', 'shipped', 'delivered', 'returned'
  final DateTime orderDate;

  ShopOrderModel({
    required this.id,
    required this.orderNumber,
    required this.productName,
    required this.customerName,
    required this.shippingAddress,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
  });

  factory ShopOrderModel.fromJson(Map<String, dynamic> json) {
    return ShopOrderModel(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      productName: json['product_name'] ?? '',
      customerName: json['customer_name'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'processing',
      orderDate: json['order_date'] != null ? DateTime.parse(json['order_date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'product_name': productName,
      'customer_name': customerName,
      'shipping_address': shippingAddress,
      'quantity': quantity,
      'total_price': totalPrice,
      'status': status,
      'order_date': orderDate.toIso8601String(),
    };
  }
}
