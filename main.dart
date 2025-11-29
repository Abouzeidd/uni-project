import 'package:flutter/material.dart';
import 'package:uni_project/core/utils/app_colors.dart';
import 'package:uni_project/features/splash/presentation/views/login_view.dart';
import 'package:uni_project/features/splash/presentation/views/signup_view.dart';
import 'package:uni_project/features/splash/presentation/views/widgets/on_boarding_view.dart';

import 'features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginView.routeName:
      return MaterialPageRoute(builder: (_) => const LoginView());
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case SignupView.routeName:
      return MaterialPageRoute(builder: (_) => const SignupView());
    default:
      // أي route مش معروف يروح صفحة افتراضية
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Page not found!')),
        ),
      );
  }
}

void main() {
  runApp(const FruitHub());
}

class FruitHub extends StatelessWidget {
  const FruitHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Cairo',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor)),
      debugShowCheckedModeBanner: false,
      // home: LoginView(),
      onGenerateRoute: onGenerateRoute,
      initialRoute: OnBoardingView.routeName,
    );
  }
}
