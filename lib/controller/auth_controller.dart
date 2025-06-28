import 'package:hf_customer_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//TODO add better error feedback
class AuthController {
  Future<bool> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
      } else if (response.user == null) {
        throw Exception("Invalid credentials");
      }

      return response.user != null;
    } on AuthException catch (e) {
   throw Exception(getAuthErrorMessages(e));
    }
    on PostgrestException{
     throw Exception(getPostgresException); 

    }
    
     catch (e) {
      throw Exception(
        "There went something wrong try again please. If the issue still persist constact support",
      );
    }
  }

 

  Future<bool> signUp(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Aanmelden faalde");
      }

      return response.user != null;
    } on AuthException catch (e) {

      throw Exception(getAuthErrorMessages((e)));
    } on PostgrestException {

     throw Exception(getPostgresException); 
    } catch (e) {
      throw Exception("Signup failed. Please try again. If issue persist please contact support");
    }
  }


   logOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      throw Exception(
        "Der is iets fout gegaan probeer het opnieuw, als dit blijft voorkomen neem contact op met support.",
      );
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

  String getAuthErrorMessages(AuthException e) {
    switch (e.code) {
      case 'user_already_exists':
        return "Een account met deze email  word al gebruikt";
      case 'email_exists':
        return "Een account word al gebruikt ";
      case 'request_timeout':
        return "Er ging iets mis probeer het  alstublieft  opnieuw";

      case "unexpected_failure":
        return "Er is iets overwachts fout gegaan probeer het opnieuw. Contact support mits de probleem bijft voorkomen";
      case "weak_password":
        return "Wachtwoord te zwak";

      default:
        return "Authenticatie faalde probeer het alstublieft opnieuw, ";
    }
  }
  //TODO Move this to more fitting controller/file  and use this as general return to not rewrite everytime
  String getPostgresException() {
    return "Er is een fout opgetreden bij het verwerken van je verzoek. Probeer het alstublieft opnieuw. Blijft het probleem zich voordoen? Neem dan contact op met onze supportafdeling.";
  }
}
