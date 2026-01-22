import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weekCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();
  final prevCtrl = TextEditingController();
  final childCtrl = TextEditingController();

  bool loading = false;

  // 👉 PUT YOUR _signup() FUNCTION HERE
  void _signup() async {
    setState(() => loading = true);

    final success = await AuthService().signup({
      "email": emailCtrl.text.trim(),
      "password": passCtrl.text,
      "full_name": nameCtrl.text,
      "height_cm": double.parse(heightCtrl.text),
      "pregnancy_week": int.parse(weekCtrl.text),
      "expected_due_date": dueDateCtrl.text,
      "previous_pregnancies": int.parse(prevCtrl.text),
      "existing_children": int.parse(childCtrl.text),
    });

    setState(() => loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: heightCtrl, decoration: const InputDecoration(labelText: "Height (cm)"), keyboardType: TextInputType.number),
            TextField(controller: weekCtrl, decoration: const InputDecoration(labelText: "Pregnancy Week"), keyboardType: TextInputType.number),
            TextField(controller: dueDateCtrl, decoration: const InputDecoration(labelText: "Expected Due Date (YYYY-MM-DD)")),
            TextField(controller: prevCtrl, decoration: const InputDecoration(labelText: "Previous Pregnancies"), keyboardType: TextInputType.number),
            TextField(controller: childCtrl, decoration: const InputDecoration(labelText: "Existing Children"), keyboardType: TextInputType.number),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    child: const Text("Signup"),
                  ),
          ],
        ),
      ),
    );
  }
}
