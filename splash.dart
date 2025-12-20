import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    await Future.delayed(const Duration(seconds: 2));

    final user = client.auth.currentUser;
    if (user != null && user.email != null) {
      Get.offAll(() => HomePage()); // Navigate to Home
    } else {
      Get.offAll(() => Login()); // Navigate to Login
    }
  }
}

class Splash extends StatelessWidget {
  Splash({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [SvgPicture.asset('assets/images/plant.svg')]),
            SvgPicture.asset('assets/images/logo.svg'),
            SvgPicture.asset(
              'assets/images/SplashBottom.svg',
              fit: BoxFit.fill,
            ),
            const CircularProgressIndicator(),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
