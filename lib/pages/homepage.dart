import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hf_customer_app/controller/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final authController = AuthController();
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await authController.logOut();
                if (!context.mounted) return;

              context.go('/login');
              } catch (e) {
                throw Exception("Went something wrong{e}");
              }
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Center(child: Text("Welcome ${user?.email ?? 'Guest'}!")),


      floatingActionButton: ElevatedButton(onPressed: () {

        authController.getUser();
    print(user);
      }, child: const Text("Test")),
    );
  }
}
