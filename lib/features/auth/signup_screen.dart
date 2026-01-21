import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  void _signup() async {
    if (passCtrl.text.length < 6) {
      _error("Password must be at least 6 characters");
      return;
    }

    setState(() => loading = true);
    final success = await AuthService()
        .signup(emailCtrl.text.trim(), passCtrl.text);

    setState(() => loading = false);

    success
        ? Navigator.pop(context)
        : _error("User already exists");
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading ? null : _signup,
            child: const Text("Create Account"),
          ),
        ]),
      ),
    );
  }
}
