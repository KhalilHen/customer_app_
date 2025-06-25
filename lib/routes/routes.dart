
import 'package:flutter/material.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/login.dart';

class Routes {


  static const String login = '/login';
  static const String homePage = '/home';


  static Map<String, WidgetBuilder> get routes => {

    login: (context) => const LoginPage(),
    homePage: (context) => const Homepage()

  };
}