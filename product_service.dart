import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

class ProductService {
  final cloud = Supabase.instance.client;

  /// 🔥 Get current user email safely
  String? get email {
    final user = cloud.auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return null;
    }
    return user.email;
  }

  /// Load all fruits
  Future<List<Fruit>> loadProducts() async {
    try {
      final res = await cloud.from('fruits').select();
      return (res as List).map((e) => Fruit.fromJson(e)).toList();
    } catch (e) {
      print("Error loading fruits: $e");
      return [];
    }
  }

  /// Increase quantity for a fruit
  Future<void> increaseQuantity(Fruit fruit) async {
    final userEmail = email;
    if (userEmail == null) return;

    try {
      final existing = await cloud
          .from('cart')
          .select('fruit_id, quantity, total_price')
          .eq('fruit_id', fruit.fruitId)
          .eq('email', userEmail)
          .maybeSingle();

      if (existing == null) {
        await cloud.from('cart').insert({
          'fruit_id': fruit.fruitId,
          'quantity': 1,
          'email': userEmail,
          'total_price': fruit.price,
        });
      } else {
        final newQuantity = existing['quantity'] + 1;
        await cloud
            .from('cart')
            .update({
              'quantity': newQuantity,
              'total_price': newQuantity * fruit.price,
            })
            .eq('fruit_id', existing['fruit_id'])
            .eq('email', userEmail);
      }
    } catch (e) {
      print("Error increasing quantity: $e");
      rethrow;
    }
  }

  /// Decrease quantity for a fruit
  Future<void> decreaseQuantity(Fruit fruit) async {
    final userEmail = email;
    if (userEmail == null) return;

    try {
      final existing = await cloud
          .from('cart')
          .select('fruit_id, quantity, total_price')
          .eq('fruit_id', fruit.fruitId)
          .eq('email', userEmail)
          .maybeSingle();

      if (existing == null) return;

      final currentQuantity = existing['quantity'];

      if (currentQuantity > 1) {
        final newQuantity = currentQuantity - 1;
        await cloud
            .from('cart')
            .update({
              'quantity': newQuantity,
              'total_price': newQuantity * fruit.price,
            })
            .eq('fruit_id', existing['fruit_id'])
            .eq('email', userEmail);
      } else {
        await cloud
            .from('cart')
            .delete()
            .eq('fruit_id', existing['fruit_id'])
            .eq('email', userEmail);
      }
    } catch (e) {
      print("Error decreasing quantity: $e");
      rethrow;
    }
  }

  /// Get quantity for a fruit
  Future<int> getQuantity(int fruitId) async {
    final userEmail = email;
    if (userEmail == null) return 0;

    try {
      final data = await cloud
          .from('cart')
          .select('quantity')
          .eq('fruit_id', fruitId)
          .eq('email', userEmail)
          .maybeSingle();

      return data == null ? 0 : data['quantity'];
    } catch (e) {
      print("Error getting quantity: $e");
      return 0;
    }
  }

  /// Fetch all cart items with fruit info
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final userEmail = email;
    if (userEmail == null) return [];

    try {
      final cartRows = await cloud
          .from('cart')
          .select('fruit_id, quantity, total_price')
          .eq('email', userEmail);

      if ((cartRows as List).isEmpty) return [];

      final fruits = await cloud
          .from('fruits')
          .select('fruit_id, name, price, image_url');

      final cartWithFruits = (cartRows as List)
          .map<Map<String, dynamic>?>((cart) {
            final fruit = (fruits as List)
                .cast<Map<String, dynamic>>()
                .firstWhere(
                  (f) => f['fruit_id'] == cart['fruit_id'],
                  orElse: () => {},
                );

            if (fruit.isEmpty) return null;

            return {
              'fruit': fruit,
              'quantity': cart['quantity'],
              'total_price': cart['total_price'],
            };
          })
          .where((item) => item != null)
          .cast<Map<String, dynamic>>()
          .toList();

      return cartWithFruits;
    } catch (e) {
      print("Error fetching cart items: $e");
      return [];
    }
  }

  /// Load all history items (orders + items + fruits)
  Future<List<Map<String, dynamic>>> loadHistory() async {
    final userEmail = email;
    if (userEmail == null) return [];

    try {
      // Load orders
      final orders = await cloud
          .from('orders')
          .select('id, total_price, status, created_at')
          .eq('email', userEmail)
          .order('created_at', ascending: false);

      if ((orders as List).isEmpty) return [];

      // Extract order IDs
      final orderIds = orders
          .cast<Map<String, dynamic>>()
          .map((o) => o['id'])
          .toList();

      // Load order items for these orders
      final orderItems = await cloud
          .from('order_items')
          .select('order_id, fruit_id, quantity, price')
          .filter('order_id', 'in', '(${orderIds.join(",")})');

      // Load fruits
      final fruits = await cloud
          .from('fruits')
          .select('fruit_id, name, price, image_url');

      // Combine data
      final historyWithFruits = orders.cast<Map<String, dynamic>>().map((
        order,
      ) {
        final items = (orderItems as List)
            .cast<Map<String, dynamic>>()
            .where((item) => item['order_id'] == order['id'])
            .map((item) {
              final fruit = (fruits as List)
                  .cast<Map<String, dynamic>>()
                  .firstWhere(
                    (f) => f['fruit_id'] == item['fruit_id'],
                    orElse: () => {},
                  );
              return {
                'fruit': fruit,
                'quantity': item['quantity'],
                'price': item['price'],
              };
            })
            .toList();

        return {
          'order_id': order['id'], // or 'order_id' if your column is named that
          'total_price': order['total_price'],
          'status': order['status'],
          'created_at': order['created_at'],
          'items': items,
        };
      }).toList();

      return historyWithFruits;
    } catch (e) {
      print("Error loading history: $e");
      return [];
    }
  }

  /// Place order with current cart items
  Future<void> placeOrder(List<Map<String, dynamic>> cartItems) async {
    final userEmail = email;
    if (userEmail == null) return;

    if (cartItems.isEmpty) return;

    try {
      // Calculate total price
      final totalPrice = cartItems.fold<double>(
        0,
        (sum, item) => sum + (item['quantity'] * (item['fruit']['price'] ?? 0)),
      );

      // Insert new order
      final orderRes = await cloud
          .from('orders')
          .insert({
            'email': userEmail,
            'total_price': totalPrice,
            'status': 'pending', // or 'placed'
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();

      if (orderRes == null || orderRes['id'] == null) {
        throw Exception("Failed to create order");
      }

      final orderId = orderRes['id'];

      // Insert order items
      final orderItems = cartItems.map((item) {
        final fruit = item['fruit'] as Map<String, dynamic>;
        return {
          'order_id': orderId,
          'fruit_id': fruit['fruit_id'],
          'quantity': item['quantity'],
          'price': fruit['price'],
        };
      }).toList();

      await cloud.from('order_items').insert(orderItems);

      // Clear cart
      final fruitIds = cartItems
          .map((item) => item['fruit']['fruit_id'])
          .toList();
      await cloud
          .from('cart')
          .delete()
          .eq('fruit_id', fruitIds)
          .eq('email', userEmail);
    } catch (e) {
      print("Error placing order: $e");
      rethrow;
    }
  }
}
