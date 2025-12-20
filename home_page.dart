// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'cart.dart';
// import 'models.dart';
// import 'home controller.dart';
//
// class HomePage extends StatelessWidget {
//   HomePage({super.key});
//
//   final HomeController controller = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Fruit Market"),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               Get.to(() => CartPage()); // No email needed
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: TextField(
//               controller: controller.searchController,
//               decoration: InputDecoration(
//                 hintText: "Search fruits...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.filteredFruits.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return GridView.builder(
//           padding: const EdgeInsets.all(12),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: .77,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//           ),
//           itemCount: controller.filteredFruits.length,
//           itemBuilder: (context, index) {
//             final Fruit fruit = controller.filteredFruits[index];
//             final int quantity = controller.quantities[fruit.fruitId] ?? 0;
//
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.green.shade300),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: fruit.imageUrl,
//                     height: 100,
//                     width: 100,
//                     fit: BoxFit.cover,
//                     placeholder: (_, __) =>
//                         const CircularProgressIndicator(strokeWidth: 2),
//                     errorWidget: (_, __, ___) => const Icon(
//                       Icons.broken_image,
//                       size: 48,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     fruit.name,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "\$${fruit.price}",
//                     style: const TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 10),
//                   // Quantity Selector
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade700,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.remove, color: Colors.white),
//                           onPressed: quantity == 0
//                               ? null
//                               : () => controller.decreaseQuantity(fruit),
//                         ),
//                         Text(
//                           quantity.toString(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.add, color: Colors.white),
//                           onPressed: () => controller.increaseQuantity(fruit),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruit_market/history_page.dart';
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
        // title: const Text("Fruit Market"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.to(() => HistoryPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final cartController = Get.put(CartController());
              cartController.loadCart(); // fetch latest cart items
              Get.to(() => CartPage());
            },
          ),
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
                    placeholder: (_, __) =>
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

                  const SizedBox(height: 10),

                  /// 🔥 REACTIVE QUANTITY (THIS IS THE FIX)
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
