import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';
import 'login.dart';

class SplashController extends GetxController {
  final client = Supabase.instance.client;

  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final user = client.auth.currentUser;
    if (user != null && user.email != null) {
      // Pass email to HomePage
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => Login());
    }
  }
}
