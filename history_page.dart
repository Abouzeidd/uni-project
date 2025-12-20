import 'package:flutter/material.dart';

import 'models.dart';
import 'order service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final OrderService orderService = OrderService();
  List<Order> orders = [];
  List<OrderItem> orderItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    setState(() => loading = true);

    try {
      // Fetch all orders for the user
      final fetchedOrders = await orderService.getUserOrders(
        'user@example.com',
      ); // replace

      // Fetch all order items
      final fetchedItems = await orderService.getAllOrderItems();

      // Map items to orders
      for (var order in fetchedOrders) {
        order.items = fetchedItems
            .where((item) => item.orderId == order.orderId)
            .toList();
      }

      setState(() {
        orders = fetchedOrders;
        loading = false;
      });
    } catch (e) {
      print("Error loading history: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(
              child: Text(
                "No previous orders found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #${order.orderId}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Date: ${order.createdAt.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(height: 20),
                        ...order.items
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Fruit ID: ${item.fruitId} x${item.quantity}",
                                    ),
                                    Text("\$${item.price.toStringAsFixed(2)}"),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        const Divider(height: 20),
                        Text(
                          "Total: \$${order.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
