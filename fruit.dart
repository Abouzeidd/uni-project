class Fruit {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Fruit({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}
