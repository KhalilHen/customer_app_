import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hf_customer_app/custom-widgets/view_cart.dart';
import 'package:hf_customer_app/custom-widgets/view_cart_button.dart';
import 'package:hf_customer_app/models/restaurant.dart';
import 'package:hf_customer_app/pages/forgot_password.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/location_page.dart';
import 'package:hf_customer_app/pages/login.dart';
import 'package:hf_customer_app/pages/onboarding/onboarding.dart';
import 'package:hf_customer_app/pages/order_confirmation_page.dart';
import 'package:hf_customer_app/pages/restaurant_overview_.dart';
import 'package:hf_customer_app/pages/restaurant_view.dart';
import 'package:hf_customer_app/pages/sign_up.dart';
import 'package:hf_customer_app/routes/bottom_nav_bar.dart';
import 'package:hf_customer_app/service/auth_gate.dart';
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
class Routes {
  static GoRouter router({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? '/',
      // navigatorKey: rootNavigatorKey,
      navigatorKey: rootNavigatorKey,
      routes: [
              StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              BottomNavBar(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const RestaurantOverviewPage(),
                ),
              ],
            ),
            // StatefulShellBranch(
            //   routes: [
            //     GoRoute(
            //       path: '/profile',
            //       builder: (context, state) => const ProfilePage(),
            //     ),
            //   ],
            // ),
          ],
        ),

        
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthGate(
            //? Here mabye later a global key to check if users is logged in
          ),
        ),

  

        GoRoute(path:'/cart', builder: (context, state) {
          final extras = state.extra as String?; 
    
          return  ViewCart(restaurantSpecialInstructions: extras);

        }
          
          
          ),
        // GoRoute(path:'/confirm-order', builder: (context, state) => const OrderConfirmationPage(),),
GoRoute(
  path: '/confirm-order',
  name: 'confirmOrder',
  builder: (context, state) {
    final extras = state.extra as Map<String, dynamic>;
    return OrderConfirmationPage(
      cartItems: extras['cartItems'],
      totalAmount: extras['total'],
      subtotal: extras['subtotal'],
      tax: extras['tax'],
      restaurantSpecialInstructions: extras['restaurantSpecialInstructions'],
      //  widget.restaurantSpecialInstructions
    );
  },
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
            final extra = state.extra;
            if(extra is! Restaurant) {
              //TODO Change this into error page
              return const Scaffold(
                body: Center(child: Text("Der ging iets mis met het ophalen van de restaurant herstart de app a.u.b"),),
              );
            }
            // final restaurant = state.extra as Restaurant;
            return RestaurantView(restaurant: extra);
          },
        ),


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
