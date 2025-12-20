import 'package:flutter/material.dart';
import 'package:fruit_market/register.dart';
import 'package:fruit_market/splash.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_controller.dart';
import 'home_page.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://scnrfszmrxbgoeicekai.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjbnJmc3ptcnhiZ29laWNla2FpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxODUzNDUsImV4cCI6MjA3OTc2MTM0NX0.C5A2NzLUybENCutEQ1RaKAdKpYp4Kdab_mXgbyAOfx0',
  );

  Get.put(CartController(), permanent: true);

  runApp(MyApp());
}

final cloud = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => Splash()),
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/register', page: () => const Register()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}
