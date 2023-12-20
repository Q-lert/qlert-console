import 'package:flutter/material.dart';
import 'package:qlert_console/consoleScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await something
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
        home: const Console());
  }
}
