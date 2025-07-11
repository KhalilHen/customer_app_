import 'package:go_router/go_router.dart';
import 'package:hf_customer_app/pages/forgot_password.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:hf_customer_app/pages/location_page.dart';
import 'package:hf_customer_app/pages/login.dart';
import 'package:hf_customer_app/pages/restaurant_overview_.dart';
import 'package:hf_customer_app/pages/sign_up.dart';

class Routes {
  static  GoRouter router({String? initialLocation}) {



return GoRouter(


initialLocation: initialLocation ?? '/',
routes: [

      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(
          //? Here mabye later a global key to check if users is logged in
        ),
      ), 


      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(
        ),
      ), 
      
        GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(        ),
      ),  GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(
        ),
      ),  GoRoute(
        path: '/homepage',
        builder: (context, state) => const Homepage(
        ),
      ),

      GoRoute(
        
        
        path: '/restaurants',
        builder: (context, state) => const RestaurantOverviewPage(),
      
      )  ,
      GoRoute(path: '/locatie', builder: (context, state) => const LocationPage()),
       GoRoute(
        path: '/error',
        builder: (context, state) => const LoginPage(
        ),
      ),
],
// errorBuilder: (context, state) => ErrorPage(
//   message: 'Page not found: ${state.uri.toString()}',
// ),
);
    
  }

}
