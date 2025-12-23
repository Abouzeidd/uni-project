
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

  bool _obscurePassword = true;
  late TapGestureRecognizer _tapRecognizer;

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
        data: {'username': userName},
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
        backgroundColor: const Color(0xFFFFF6FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Register',
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

              /// USERNAME
              CustomTextFormField(
                hintText: 'Username',
                textInputType: TextInputType.name,
                controller: userNameController,
              ),

              const SizedBox(height: 16),

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

              /// REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// DIVIDER
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Already have an account?'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 8),

              /// LOGIN TEXT
              RichText(
                text: TextSpan(
                  text: 'Login',
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
