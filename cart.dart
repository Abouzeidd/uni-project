import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  // 🔥 استخدم الـ CartController المشترك
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        // ✅ Empty cart check
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty 🛒",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            // 🛒 List of cart items
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final fruit = item['fruit'];
                  final qty = item['quantity'];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: Image.network(
                        fruit['image_url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(fruit['name']),
                      subtitle: Text("Price: \$${fruit['price']} × $qty"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            qty.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 💰 Total price section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      "\$${controller.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🟢 Place Order button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.cartItems.isEmpty) {
                      Get.snackbar(
                        "Cart empty",
                        "Add some items before placing an order",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    try {
                      await controller.placeOrder();
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to place order. Try again!",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Place Order'),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
