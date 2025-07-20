import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';


//!!
//TODO Test dit later of er  geen brekende bugs zijn.  Die de gehele flow kunnen verstoren
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool isFirstTimeUser;
  late bool isSecondTimeUser;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkOnboardingAndNavigate();
  }

  Future<void> checkOnboardingAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

      if (hasSeenOnboarding) {
        if (!mounted) return;

        context.go('/restaurants');
      } else {
        // First/second time user -> go to onboarding
        if (!mounted) return;

        context.go('/onboarding/welcome');
      }
    } catch (e) {
      // Default to onboarding if error
      if (!context.mounted) return;
        // if (!mounted) return;
      

      context.go('/onboarding/welcome');
    } finally {
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {

    if(isLoading) {

    return const Scaffold(
body:  Center(
  child: CircularProgressIndicator(),
),

    );

    }
    return const Scaffold(

      body: Center(
        child: Text("Redirecting"),
      ),
    );


  }
}
