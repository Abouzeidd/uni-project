import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart.dart';
import 'cart_controller.dart';
import 'home controller.dart';
import 'models.dart';
import 'survey_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Get.defaultDialog(
              title: "Logout",
              middleText: "Are you sure you want to logout?",
              textConfirm: "Yes",
              textCancel: "Cancel",
              onConfirm: () {
                Get.back();
                Get.find<HomeController>().logout();
              },
            );
          },
        ),
        title: Obx(() => Text("Welcome ${controller.username.value} 👋")),
        backgroundColor: Colors.green,
        actions: [
          Obx(() {
            // Calculate total items in cart
            final totalItems = controller.quantities.values.fold<int>(
              0,
              (sum, quantity) => sum + quantity,
            );

            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    final cartController = Get.put(CartController());
                    cartController.loadCart();
                    Get.to(() => CartPage());
                  },
                ),
                // Badge showing cart item count
                if (totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 5,
                      ),
                      child: Text(
                        totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search fruits...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.filteredFruits.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .77,
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
                    placeholder: (__, _) =>
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
                  const SizedBox(height: 8),

                  // 🔹 Clickable "Rate" word
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => SurveyPage(
                          fruit: fruit,
                          userEmail: '', // تأكد أن عندك userEmail
                        ),
                      );
                    },
                    child: const Text(
                      "Rate",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 Quantity controls
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
