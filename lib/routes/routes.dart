import 'package:flutter/material.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/login.dart';
import 'package:hf_customer_app/pages/sign_up.dart';

class Routes {
  static const String login = '/login';
  static const String homePage = '/home';
  static const String signUp = '/sign-up';
  static const String resetPasswordpage = '/reset-password';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    homePage: (context) => const Homepage(),
    signUp: (context) => const SignUpPage(),
    // resetPasswordpage: (context) => const ResetPasswordPage(),
  };
}
