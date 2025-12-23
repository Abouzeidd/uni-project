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
        backgroundColor: const Color(0xFFFFF6FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// EMAIL
              CustomTextFormField(
                hintText: 'Email address',
                textInputType: TextInputType.emailAddress,
                controller: emailController,
              ),

              const SizedBox(height: 16),

              /// PASSWORD
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

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// DIVIDER + TEXT
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Don't have an account?"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 8),

              /// SIGN UP
              RichText(
                text: TextSpan(
                  text: 'Sign Up',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: _tapRecognizer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
