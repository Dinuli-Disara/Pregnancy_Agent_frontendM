import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'auth_service.dart';
import '../navigation/main_navigation_screen.dart';
import '../../core/constants/colors.dart'; // Assuming you have this

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
      SnackBar(
        content: Text("Login Success"),
        backgroundColor: AppColors.primary,
      ),
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
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // App Icon Section
                Center(
                  child: Column(
                    children: [
                      // App Icon Container
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/icon/mommy.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback icon if image doesn't load
                              return Icon(
                                Icons.family_restroom,
                                size: 60,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Welcome text
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to continue your pregnancy journey",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                
                // Email field
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Password field
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Forgot password (optional)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add forgot password functionality
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            "Login",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "or continue with",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Sign up section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Add some extra space at the bottom for better scrolling
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}