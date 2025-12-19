import 'package:flutter/material.dart';
import 'package:pregnancy_agent_app/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pregnancy AI Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Color(0xFFFAF8F9),
      ),
      home: const SplashScreen(),
    );
  }
}