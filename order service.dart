import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

class OrderService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Insert a new order into the orders table
  Future<Order?> insertOrder({
    required String email,
    required double totalAmount,
    required List<OrderItem> items,
  }) async {
    try {
      // Insert order
      final orderRes = await supabase
          .from('orders')
          .insert({
            'email': email,
            'total_amount': totalAmount,
            'status': 'pending',
          })
          .select()
          .single();

      final orderId = orderRes['order_id'] as String;

      // Insert items in order_items table
      for (var item in items) {
        await supabase.from('order_items').insert({
          'order_id': orderId,
          'fruit_id': item.fruitId,
          'quantity': item.quantity,
          'price': item.price,
        });
      }

      // Return inserted order object
      return Order(
        orderId: orderId,
        totalPrice: totalAmount,
        status: 'pending',
        createdAt: DateTime.parse(orderRes['created_at']),
        email: email,
        items: items,
      );
    } catch (e) {
      print("Error inserting order: $e");
      return null;
    }
  }

  /// Fetch all orders for a user
  Future<List<Order>> getUserOrders(String email) async {
    try {
      final ordersRes = await supabase
          .from('orders')
          .select('*')
          .eq('email', email)
          .order('created_at', ascending: false);

      final itemsRes = await supabase.from('order_items').select('*');

      final allOrders = (ordersRes as List)
          .map((o) => Order.fromJson(o as Map<String, dynamic>))
          .toList();

      final allItems = (itemsRes as List)
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList();

      // Map items to their orders
      for (var order in allOrders) {
        order.items = allItems
            .where((item) => item.orderId == order.orderId)
            .toList();
      }

      return allOrders;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  /// Fetch all order items (optional)
  Future<List<OrderItem>> getAllOrderItems() async {
    try {
      final res = await supabase.from('order_items').select('*');
      return (res as List)
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching order items: $e");
      return [];
    }
  }
}
