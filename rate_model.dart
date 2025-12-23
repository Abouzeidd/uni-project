class Rate {
  int? id;
  String fruitId;
  String userEmail;
  int productRate;
  int serviceRate;
  String comment;
  DateTime createdAt;

  Rate({
    this.id,
    required this.fruitId,
    required this.userEmail,
    required this.productRate,
    required this.serviceRate,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fruit_id': fruitId,
      'user_email': userEmail,
      'product_rate': productRate,
      'service_rate': serviceRate,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
