import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final emailController = TextEditingController();
    final codeController = TextEditingController();
    final newPassword = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Reset password", style: TextStyle()),
                  TextFormField(
                    controller: emailController,

                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vul iets in";
                      } else if (!value.contains('@')) {
                        //TODO Add perhaps  instead of this check if the emails match one in the database
                        return "Vul een geldige email in";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),
                  TextFormField(
                    controller: codeController,

                    decoration: const InputDecoration(
                      hintText: "32244242",
                      labelText: "Code",
                      prefixIcon: Icon(Icons.code),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vul iets in";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),
                  TextFormField(
                    controller: newPassword,

                    decoration: const InputDecoration(
                      labelText: "Wachtwoord",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    // keyboardType: TextInputType.visiblePassword, //?? Find out if this is usefull
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Bevestig wachtwoord",
                      // prefixIcon:
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Dit veld moet ingevult worden";
                      }
                      if (value != newPassword.text) {
                        return "Wachtwoord komen niet overeen";
                      }

                      return null;
                    },
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
