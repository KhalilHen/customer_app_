import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }
}
