import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/login.dart';

import 'package:integration_test/integration_test.dart';

import 'package:hf_customer_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Testing logging in with incorrect credentials', (tester) async {
    

 app.main(initialLocation: '/login');
await tester.pumpAndSettle();

final testEmail = "invalid@hotmail.com";
final testPassword = "123";
    await tester.pumpAndSettle();
    final Finder  emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.byKey(const Key('passwordField'));

    await Future.delayed(const Duration(seconds: 10));

    final Finder loginButton = find.text("Login");

    await tester.enterText(emailField, testEmail);
    await tester.enterText(passwordField, testPassword);
    await Future.delayed(const Duration(seconds: 5));
    
    await tester.tap(loginButton);
    await tester.pump();


    await Future.delayed(const Duration(seconds: 5));

    await tester.pumpAndSettle();

    expect(find.textContaining("Welcome Back"), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}