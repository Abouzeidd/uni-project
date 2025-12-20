import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'custom_text_field.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  late TapGestureRecognizer _tapRecognizer;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () => Get.off(() => const Login());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    _tapRecognizer.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final userName = userNameController.text.trim();

    if (email.isEmpty || password.isEmpty || userName.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': userName, // 🔥 saved in auth metadata
        },
      );

      Get.snackbar(
        'Success',
        'Account created. Please login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.off(() => const Login());
    } catch (e) {
      Get.snackbar(
        'Register Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Username',
                textInputType: TextInputType.name,
                controller: userNameController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Email address',
                textInputType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Password',
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Login',
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
