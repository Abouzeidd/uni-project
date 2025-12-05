import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://scnrfszmrxbgoeicekai.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjbnJmc3ptcnhiZ29laWNla2FpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxODUzNDUsImV4cCI6MjA3OTc2MTM0NX0.C5A2NzLUybENCutEQ1RaKAdKpYp4Kdab_mXgbyAOfx0',
  );

  runApp(FruitApp());
}

final cloud = Supabase.instance.client;

class FruitApp extends StatelessWidget {
  FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
