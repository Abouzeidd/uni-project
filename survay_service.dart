import 'package:supabase_flutter/supabase_flutter.dart';

class SurveyService {
  final _db = Supabase.instance.client;

  /// Get current user email
  String? get email {
    final user = _db.auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return null;
    }
    return user.email;
  }

  /// Submit survey
  Future<void> submitSurvey({
    required int fruitId,
    required int productRate,
    required int serviceRate,
    required String comment,
  }) async {
    final userEmail = email;
    if (userEmail == null) {
      throw Exception("User not logged in");
    }

    await _db.from('surveys').insert({
      'fruit_id': fruitId,
      'product_rate': productRate,
      'service_rate': serviceRate,
      'comment': comment,
      'user_email': userEmail,
    });
  }
}
