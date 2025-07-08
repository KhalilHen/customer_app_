import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

// !! Temporary stoped working on it
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  final authController = AuthController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text('Enter your email to reset your password'),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vul uw email in';
                  if (!value.contains('@')) return 'Vul een geldige email in';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {


                          // authController.resetPassword();
                        }
                      },
                      child: const Text('Send Reset Link'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
