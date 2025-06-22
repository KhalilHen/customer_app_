import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hf_customer_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const bool isProd = bool.fromEnvironment('dart.vm.product');

  if (isProd) {
    await dotenv.load(fileName: ".env.prod");
  } else {
    await dotenv.load(fileName: ".env.dev");
  }

  final showDebugBanner = dotenv.env['SHOW_DEBUG_BANNER'] == 'true';

  final supabaseUrl =
      dotenv.env['SUPABASE_URL'] ??
      (throw Exception('Something went wrong with the database!'));
  final supabaseAnonKey =
      dotenv.env['SUPABASE_ANON_KEY'] ??
      (throw Exception('Something went wrong with the database!'));
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MainApp(showDebugBanner: showDebugBanner));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.showDebugBanner});
  final bool showDebugBanner;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: showDebugBanner,

      home: const Homepage(),
    );
  }
}
