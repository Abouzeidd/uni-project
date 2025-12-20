import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_controller.dart';
import 'login.dart';
import 'models.dart';
import 'product_service.dart';

class HomeController extends GetxController {
  final ProductService productService = ProductService();

  var fruits = <Fruit>[].obs;
  var filteredFruits = <Fruit>[].obs;
  var quantities = <int, int>{}.obs; // fruitId -> quantity
  final searchController = TextEditingController();

  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Future.microtask(() => Get.offAll(() => Login()));
      return;
    }

    username.value = user.userMetadata?['username'] ?? 'User';

    loadFruits();

    searchController.addListener(() {
      filterFruits(searchController.text);
    });
  }

  Future<void> loadFruits() async {
    final loadedFruits = await productService.loadProducts();
    fruits.assignAll(loadedFruits);
    filteredFruits.assignAll(loadedFruits);

    for (final fruit in loadedFruits) {
      quantities[fruit.fruitId] = await productService.getQuantity(
        fruit.fruitId,
      );
    }
  }

  void filterFruits(String query) {
    if (query.isEmpty) {
      filteredFruits.assignAll(fruits);
    } else {
      filteredFruits.assignAll(
        fruits.where((f) => f.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  /// 🔥 Increase quantity
  Future<void> increaseQuantity(Fruit fruit) async {
    await productService.increaseQuantity(fruit);
    quantities[fruit.fruitId] = (quantities[fruit.fruitId] ?? 0) + 1;

    // 🔥 Update cart immediately
    try {
      final CartController cartController = Get.find<CartController>();
      await cartController.loadCart();
    } catch (e) {
      print("CartController not found: $e");
    }
  }

  /// 🔥 Decrease quantity
  Future<void> decreaseQuantity(Fruit fruit) async {
    final current = quantities[fruit.fruitId] ?? 0;
    if (current == 0) return;

    await productService.decreaseQuantity(fruit);
    quantities[fruit.fruitId] = current - 1;

    // 🔥 Update cart immediately
    try {
      final CartController cartController = Get.find<CartController>();
      await cartController.loadCart();
    } catch (e) {
      print("CartController not found: $e");
    }
  }

  void resetQuantities() {
    quantities.clear();

    for (final fruit in fruits) {
      quantities[fruit.fruitId] = 0;
    }

    quantities.refresh();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    // Clear all GetX controllers
    Get.deleteAll(force: true);

    Get.offAll(() => Login());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
