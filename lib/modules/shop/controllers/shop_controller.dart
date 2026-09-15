import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/shop_repository.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class ShopController extends GetxController {
  final ShopRepository _repository = ShopRepository();

  final isLoading = true.obs;
  final products = <ProductModel>[].obs;
  final orders = <ShopOrderModel>[].obs;
  final selectedStateFilter = 'All States'.obs;

  // Add Product Form Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final stateController = TextEditingController(text: 'Assam');
  final categoryController = TextEditingController(text: 'Handicrafts');
  final priceController = TextEditingController();
  final stockController = TextEditingController(text: '10');

  @override
  void onInit() {
    super.onInit();
    loadShopData();
  }

  Future<void> loadShopData() async {
    try {
      isLoading.value = true;
      final pRes = await _repository.getProducts();
      if (pRes.success && pRes.data != null) {
        products.assignAll(pRes.data!);
      }
      final oRes = await _repository.getOrders();
      if (oRes.success && oRes.data != null) {
        orders.assignAll(oRes.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shop catalog');
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    if (selectedStateFilter.value == 'All States') return products;
    return products.where((p) => p.originState == selectedStateFilter.value).toList();
  }

  Future<void> submitProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Validation', 'Product name and price are required');
      return;
    }
    try {
      isLoading.value = true;
      final res = await _repository.createProduct({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'origin_state': stateController.text.trim(),
        'category': categoryController.text.trim(),
        'base_price': double.tryParse(priceController.text) ?? 500,
        'stock_quantity': int.tryParse(stockController.text) ?? 10,
      });
      if (res.success) {
        Get.snackbar('Success', res.message);
        loadShopData();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    stateController.dispose();
    categoryController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
