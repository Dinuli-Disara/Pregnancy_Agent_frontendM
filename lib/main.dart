import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'core/constants/colors.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const PregnancyAgentApp());
}

class PregnancyAgentApp extends StatelessWidget {
  const PregnancyAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pregnancy AI Agent")),
      body: const Center(
        child: Text(
          "Welcome inside the app \nAgent will live here",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
