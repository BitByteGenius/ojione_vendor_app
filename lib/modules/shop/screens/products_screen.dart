import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';
import 'shop_dashboard_screen.dart';

class ProductsScreen extends GetView<ShopController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShopDashboardScreen();
  }
}
