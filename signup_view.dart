import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_project/features/splash/presentation/views/widgets/signup_view_body.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const routeName = 'signup';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: Center(
          child: Text(
            'تسجيل الدخول',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
      ),
      body: SignupViewBody(),
    );
  }
}
