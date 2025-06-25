import 'package:hf_customer_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//TODO add better error handeling
// TODO Check if it's needed to add a checkEmail function if users wants to sign up account with email already been used./
class AuthController {
  login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
      } else if (response.user == null) {
        throw Exception("Invalid credentials");
      }
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {

        throw Exception("Invalid password or email");
      } else {
        throw Exception("Login failed");
      }
    } catch (e) {
      throw Exception(
        "There went something wrong try again please. If the issue still persist constact support",
      );
    }
  }

   logOut() async {
    try {
      final response = await Supabase.instance.client.auth.signOut();

    } catch (e) {


        throw Exception("Der is iets fout gegaan probeer het opnieuw, als dit blijft voorkomen neem contact op met support.");
    }
  }

  Future<User?> getUser() async {
    final User? user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    } else {
      return user;
    }
  }
  bool isLoggedIn() {
    return supabase.auth.currentUser != null;

  }
}
