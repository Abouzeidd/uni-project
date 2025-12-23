import 'package:fruit_market/rate_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RateService {
  final supabase = Supabase.instance.client;

  /// INSERT RATE
  Future<void> insertRate(Rate rate) async {
    try {
      final inserted = await supabase.from('rate').insert({
        'fruit_id': rate.fruitId,
        'user_email': rate.userEmail,
        'product_rate': rate.productRate,
        'service_rate': rate.serviceRate,
        'comment': rate.comment,
        'created_at': rate.createdAt.toIso8601String(),
      }).select(); // مهم جدًا: `.select()` عشان يرجع البيانات بعد الإدخال

      if (inserted == null || (inserted as List).isEmpty) {
        throw Exception("Failed to insert rate");
      }

      print("✅ Rate inserted: ${rate.toMap()}");
    } catch (e) {
      print("❌ Error inserting rate: $e");
      throw Exception("Failed to save rating");
    }
  }

  /// GET RATES BY FRUIT
  Future<List<Rate>> getRatesByFruit(String fruitId) async {
    try {
      final data = await supabase
          .from('rate')
          .select()
          .eq('fruit_id', fruitId)
          .order('created_at', ascending: false);

      if (data == null) return [];

      final list = data as List<dynamic>;
      return list.map((m) => Rate(
        id: m['id'] as int,
        fruitId: m['fruit_id'] as String,
        userEmail: m['user_email'] as String,
        productRate: m['product_rate'] as int,
        serviceRate: m['service_rate'] as int,
        comment: m['comment'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
      )).toList();
    } catch (e) {
      print("❌ Error fetching rates: $e");
      return [];
    }
  }
}
