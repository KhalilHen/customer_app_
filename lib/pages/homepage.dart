import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/auth_controller.dart';
import 'package:hf_customer_app/pages/login.dart';
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
    return  Scaffold(
      appBar: AppBar(
        actions:  [
          IconButton(onPressed:  () async {

try {

await authController.logOut();    
                            if (!context.mounted) return;

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));

}
catch (e){

throw Exception("Went something wrong{e}");
}

  },
  
   icon: const Icon(Icons.logout))
        ],
      ),

body: Center(
  child: Text("Welcome ${user?.email ??'Guest'}!"
  
   ),
),

    );
  }
}
