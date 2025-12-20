import 'package:get/get.dart';

import 'home controller.dart';
import 'models.dart';
import 'product_service.dart';

class CartController extends GetxController {
  final ProductService productService = ProductService();

  var cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  /// Load cart items from backend
  Future<void> loadCart() async {
    try {
      final items = await productService.getCartItems();
      cartItems.assignAll(items);
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  /// Increase quantity of a cart item
  Future<void> increaseQuantity(Map<String, dynamic> item) async {
    try {
      final fruitMap = item['fruit'] as Map<String, dynamic>?;
      if (fruitMap == null) return;

      final fruit = Fruit.fromJson(fruitMap);
      await productService.increaseQuantity(fruit);

      await loadCart(); // reload cart from backend
    } catch (e) {
      print("Error increasing quantity: $e");
    }
  }

  Future<void> decreaseQuantity(Map<String, dynamic> item) async {
    try {
      final fruitMap = item['fruit'] as Map<String, dynamic>?;
      if (fruitMap == null) return;

      final fruit = Fruit.fromJson(fruitMap);
      await productService.decreaseQuantity(fruit);

      await loadCart();
    } catch (e) {
      print("Error decreasing quantity: $e");
    }
  }

  /// Calculate total price
  double get total => cartItems.fold(0, (sum, item) {
    final qty = item['quantity'] ?? 0;
    final price = (item['fruit']?['price'] ?? 0).toDouble();
    return sum + (qty * price);
  });

  /// Place order
  Future<void> placeOrder() async {
    try {
      await productService.placeOrder(cartItems);

      // Clear cart state
      cartItems.clear();

      // Reset quantities in HomeController
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.resetQuantities();
      }

      Get.snackbar("Success", "Order placed successfully!");
    } catch (e) {
      print("Error placing order: $e");
      Get.snackbar("Error", "Failed to place order");
    }
  }
}
