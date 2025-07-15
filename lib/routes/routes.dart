import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/pages/forgot_password.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/location_page.dart';
import 'package:hf_customer_app/pages/login.dart';
import 'package:hf_customer_app/pages/onboarding/onboarding.dart';
import 'package:hf_customer_app/pages/restaurant_overview_.dart';
import 'package:hf_customer_app/pages/restaurant_view.dart';
import 'package:hf_customer_app/pages/sign_up.dart';
import 'package:hf_customer_app/service/auth_gate.dart';

class Routes {
  static GoRouter router({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthGate(
            //? Here mabye later a global key to check if users is logged in
          ),
        ),

        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/homepage',
          builder: (context, state) => const Homepage(),
        ),

        //* Onboarding
        GoRoute(
          path: '/onboarding/welcome',

          builder: (context, state) => const Onboarding(),
        ),

        // * Restaurants
        GoRoute(
          path: '/restaurants',
          builder: (context, state) => const RestaurantOverviewPage(),
        ),
        GoRoute(
          path: '/restaurant-specific',

          builder: (context, state) {
            final restaurant = state.extra as Restaurant;
            return RestaurantView(restaurant: restaurant);
          },
        ),

// GoRoute(path: '/test-restaurant',
//   builder: (context, state) => const RestaurantView(),
// ),
        GoRoute(
          path: '/locatie',
          builder: (context, state) => const LocationPage(),
        ),
        GoRoute(path: '/error', builder: (context, state) => const LoginPage()),
      ],
      // errorBuilder: (context, state) => ErrorPage(
      //   message: 'Page not found: ${state.uri.toString()}',
      // ),
    );
  }
}
