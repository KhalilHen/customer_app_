import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hf_customer_app/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
Future<void> main({String? initialLocation}) async {
  WidgetsFlutterBinding.ensureInitialized();
  //!! This way for now to get a fast mvp done

  await Supabase.initialize(
  // secret key
  );
  //TODO Improve this later so it's compatible with flutter analyze
  // const bool isProd = bool.fromEnvironment('dart.vm.product');

  // if (isProd) {
  //   await dotenv.load(fileName: ".env.prod");
  // } else {
  //   await dotenv.load(fileName: ".env.dev");
  // }

  // final showDebugBanner = dotenv.env['SHOW_DEBUG_BANNER'] == 'true';

  // final supabaseUrl =
  //     dotenv.env['SUPABASE_URL'] ??
  //     (throw Exception('Something went wrong with the database!'));
  // final supabaseAnonKey =
  //     dotenv.env['SUPABASE_ANON_KEY'] ??
  //     (throw Exception('Something went wrong with the database!'));
  // await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  // runApp(MainApp(showDebugBanner: showDebugBanner));

  // runApp(const MainApp());
    runApp(MainApp(initialLocation: initialLocation));

}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  final String? initialLocation;

  const MainApp({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.router(initialLocation: initialLocation),
    );
  }
}
