import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'custom_text_field.dart';
import 'home_page.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () => Get.off(() => const Register());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _tapRecognizer.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.session != null) {
        Get.offAll(() => HomePage());
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Invalid email or password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Email address',
                textInputType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 16),

              /// 🔥 PASSWORD WITH EYE ICON
              CustomTextFormField(
                hintText: 'Password',
                textInputType: TextInputType.visiblePassword,
                controller: passwordController,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(height: 30),

              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _tapRecognizer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
