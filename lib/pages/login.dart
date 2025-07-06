import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hf_customer_app/controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = AuthController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const Key("emailField"),
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vul iets in";
                      } else if (!value.contains('@')) {
                        return 'Vul een geldige email in';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key("passwordField"),

                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Wachtwoord',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vul iets in";
                      }

                      return null;
                    },
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/signup'),

                        child: const Text("Sign up"),
                      ),
                      const SizedBox(width: 40),
                      TextButton(
                        onPressed: () => context.push('/forgot-password'),
                      
                        child: const Text("Forgot password?"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      //? Mabye add a way too not be able to  submit multiple times at once
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final succes = await authController.login(
                              emailController.text,
                              passwordController.text,
                            );

                            if (succes) {
                              if (!context.mounted) return;

                             context.go('/homepage');
                            }
                          } catch (e) {
                            // formKey.currentState!.reset();
                            passwordController.clear();
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().replaceFirst('Exception: ', ''),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
