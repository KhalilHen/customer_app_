import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/sign_up.dart';

import 'package:integration_test/integration_test.dart';

import 'package:hf_customer_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Testing signing up with existing  email', (tester) async {
    

 app.main(initialLocation: '/signup');
await tester.pumpAndSettle();

    final testEmail = "test@hotmail.com";

    await tester.pumpAndSettle();
    final Finder  emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.byKey(const Key('passwordField'));

    await Future.delayed(const Duration(seconds: 10));

    final Finder registerButton = find.text("Register");

    await tester.enterText(emailField, testEmail);
    await tester.enterText(passwordField, "test12345");
    await Future.delayed(const Duration(seconds: 5));
    
    await tester.tap(registerButton);
    await tester.pump();


    await Future.delayed(const Duration(seconds: 5));

    await tester.pumpAndSettle();
    expect(find.textContaining("Registreer"), findsOneWidget);

    expect(find.byType(SignUpPage), findsOneWidget);
  });
}