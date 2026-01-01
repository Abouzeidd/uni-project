import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruit_market/survay_page.dart';
import 'package:get/get.dart';

import 'cart.dart';
import 'cart_controller.dart';
import 'home controller.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Welcome ${controller.username.value} 👋")),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final cartController = Get.put(CartController());
              cartController.loadCart();
              Get.to(() => CartPage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.filteredFruits.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.77,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.filteredFruits.length,
          itemBuilder: (_, index) {
            final Fruit fruit = controller.filteredFruits[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: fruit.imageUrl,
                    height: 100,
                    placeholder: (_, _) =>
                        const CircularProgressIndicator(strokeWidth: 4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fruit.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text("\$${fruit.price}"),
                  const SizedBox(height: 6),

                  GestureDetector(
                    onTap: () {
                      Get.to(() => SurveyPage(fruit: fruit));
                    },
                    child: const Text(
                      "Rate?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    final quantity = controller.quantities[fruit.fruitId] ?? 0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: quantity == 0
                                ? null
                                : () => controller.decreaseQuantity(fruit),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () => controller.increaseQuantity(fruit),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
