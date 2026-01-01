class Order {
  final String orderId;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final String email;

  List<OrderItem> items;

  Order({
    required this.orderId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.email,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json['order_id'],
    totalPrice: (json['total_amount'] as num).toDouble(),
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    email: json['email'] ?? '',
  );
}

class OrderItem {
  final String orderId;
  final int fruitId;
  final int quantity;
  final double price;

  OrderItem({
    required this.orderId,
    required this.fruitId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    orderId: json['order_id'],
    fruitId: json['fruit_id'],
    quantity: json['quantity'],
    price: (json['price'] as num).toDouble(),
  );
}

class Fruit {
  final int fruitId;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  Fruit({
    required this.fruitId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
  factory Fruit.fromJson(Map<String, dynamic> json) => Fruit(
    fruitId: json['fruit_id'],
    name: json['name'],
    price: double.parse(json['price'].toString()),
    description: json['description'],
    imageUrl: json['image_url'],
  );
}
