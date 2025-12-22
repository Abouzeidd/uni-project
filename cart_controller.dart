import 'package:get/get.dart';

import 'home controller.dart';
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

  /// Calculate total price
  double get total => cartItems.fold(0, (sum, item) {
    final qty = item['quantity'] ?? 0;
    final price = (item['fruit']?['price'] ?? 0).toDouble();
    return sum + (qty * price);
  });

  /// Place order
  Future<void> placeOrder() async {
    try {
      // Only the critical operation in try-catch
      await productService.placeOrder(cartItems);
    } catch (e) {
      print("Error placing order: $e");
      Get.snackbar("Error", "Failed to place order");
      return; // Exit early if order fails
    }

    // Post-order operations (non-critical)
    try {
      cartItems.clear();

      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.resetQuantities();
      }

      // Optional: Reload cart from backend to ensure sync
      await loadCart();
    } catch (e) {
      print("Error cleaning up after order: $e");
    }

    // Always show success since order was placed
    Get.snackbar(
      "Success",
      "Order placed successfully!"
          "coming in 30 minutes",
    );
  }
}
