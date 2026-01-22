import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'auth_service.dart';
import '../navigation/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;
  bool loading = false;

  void _login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.length < 6) {
      _error("Invalid email or password");
      return;
    }

    setState(() => loading = true);

    final result = await AuthService()
        .login(emailCtrl.text.trim(), passCtrl.text);

    setState(() => loading = false);

    if (result != null) {
      _success();
    } else {
      _error("Login failed. Check email/password.");
    }
  }

  void _success() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Success")),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    });
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B5CFF), Color(0xFFFF7DA8)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Login", style: TextStyle(fontSize: 22)),
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    TextField(
                      controller: passCtrl,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: loading ? null : _login,
                      child: Text(loading ? "Loading..." : "Login"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      ),
                      child: const Text("Create account"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
