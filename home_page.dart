import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fruit.dart';
import 'product_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productService = ProductService();
  final fruits = <Fruit>[].obs;
  final searchController = TextEditingController();
  final filteredFruits = <Fruit>[].obs;

  @override
  void initState() {
    super.initState();
    loadFruits();

    // Listen to search input changes
    searchController.addListener(() {
      filterFruits(searchController.text);
    });
  }

  Future<void> loadFruits() async {
    fruits.value = await productService.loadProducts();
    filteredFruits.value = fruits; // Initially, show all fruits
  }

  void filterFruits(String query) {
    if (query.isEmpty) {
      filteredFruits.value = fruits;
    } else {
      filteredFruits.value = fruits
          .where(
            (fruit) => fruit.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Fruit Market"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart screen here
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search fruits...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
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
        if (filteredFruits.isEmpty) {
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
          itemCount: filteredFruits.length,
          itemBuilder: (context, index) {
            final fruit = filteredFruits[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: fruit.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fruit.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${fruit.price}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await productService.addToCart(fruit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${fruit.name} added to cart"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(90, 36),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
