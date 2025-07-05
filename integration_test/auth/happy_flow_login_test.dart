 // !! Made seperate files cause there were too many constant issues when doing all in 1 file which i couldn't  solve
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hf_customer_app/pages/homepage.dart';

import 'package:integration_test/integration_test.dart';

import 'package:hf_customer_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Testing logging in with correct credentials', (tester) async {
    

 app.main(initialLocation: '/login');
await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    final Finder  emailField = find.byKey(const Key('emailField'));
    final Finder passwordField = find.byKey(const Key('passwordField'));

    await Future.delayed(const Duration(seconds: 10));

    final Finder loginButton = find.text("Login");

    await tester.enterText(emailField, "test@hotmail.com");
    await tester.enterText(passwordField, "test");
    await Future.delayed(const Duration(seconds: 5));
    
    await tester.tap(loginButton);
    await tester.pump();


    await Future.delayed(const Duration(seconds: 5));

    await tester.pumpAndSettle();

    expect(find.textContaining("Welcome"), findsOneWidget);
    expect(find.byType(Homepage), findsOneWidget);
  });
}