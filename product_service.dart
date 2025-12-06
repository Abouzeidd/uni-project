import 'package:fruit_market/main.dart';

import 'fruit.dart';

class ProductService {
  Future<List<Fruit>> loadProducts() async {
    try {
      final res = await cloud.from('fruits').select() as List<dynamic>;
      return res.map((e) => Fruit.fromJson(e)).toList();
    } catch (e) {
      print("Error loading fruits: $e");
      return [];
    }
  }

  Future<void> addToCart(Fruit fruit) async {
    await cloud.from('cart').insert({
      'name': fruit.name,
      'quantity': 1,
      'total_price': fruit.price,
    });
  }
}
