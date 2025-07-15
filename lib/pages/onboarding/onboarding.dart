import 'package:flutter/material.dart';
import 'package:hf_customer_app/service/onboarding_service.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      body: const Center(child: Text("Welcome onboarding"),),



      floatingActionButton: FloatingActionButton(onPressed: () async {

        await OnboardingService.markOnboardingAsSeen();
        
      }),
    );
  }
}