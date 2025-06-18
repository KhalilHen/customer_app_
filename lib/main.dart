import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main()  async {

  //!! It can't find the different env find it out later
  // const env = String.fromEnvironment('env', defaultValue: 'dev');

  // await dotenv.load(fileName: '.env');
  runApp( const MainApp());
}

class MainApp extends StatelessWidget {
    const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),    
      ),
    );
  }
}
