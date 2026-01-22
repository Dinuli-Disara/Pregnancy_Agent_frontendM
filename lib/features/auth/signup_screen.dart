import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../../core/constants/colors.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final weekCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final prevCtrl = TextEditingController();
  final childCtrl = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  DateTime? selectedDueDate;
  bool passwordsMatch = false;
  bool passwordTouched = false;
  bool confirmPasswordTouched = false;

  @override
  void initState() {
    super.initState();
    
    // Listen for password changes to validate match
    passwordCtrl.addListener(_validatePasswords);
    confirmPasswordCtrl.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    passwordCtrl.removeListener(_validatePasswords);
    confirmPasswordCtrl.removeListener(_validatePasswords);
    super.dispose();
  }

  void _validatePasswords() {
    final password = passwordCtrl.text;
    final confirmPassword = confirmPasswordCtrl.text;
    
    setState(() {
      if (password.isNotEmpty && confirmPassword.isNotEmpty) {
        passwordsMatch = password == confirmPassword;
      } else {
        passwordsMatch = false;
      }
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        selectedDueDate = picked;
        dueDateCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _signup() async {
    // Validate required fields
    if (fullNameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        confirmPasswordCtrl.text.isEmpty ||
        weekCtrl.text.isEmpty ||
        dueDateCtrl.text.isEmpty) {
      _showError("Please fill in all required fields");
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailCtrl.text)) {
      _showError("Please enter a valid email address");
      return;
    }

    // Validate password length
    if (passwordCtrl.text.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    // Validate password match
    if (!passwordsMatch) {
      _showError("Passwords do not match");
      return;
    }

    // Validate pregnancy week
    final week = int.tryParse(weekCtrl.text);
    if (week == null || week < 1 || week > 42) {
      _showError("Please enter a valid pregnancy week (1-42)");
      return;
    }

    // Validate height if provided
    if (heightCtrl.text.isNotEmpty) {
      final height = double.tryParse(heightCtrl.text);
      if (height == null || height < 100 || height > 250) {
        _showError("Please enter a valid height (100-250 cm)");
        return;
      }
    }

    setState(() => loading = true);

    try {
      final success = await AuthService().signup({
        "full_name": fullNameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "password": passwordCtrl.text,
        "pregnancy_week": week!,
        "expected_due_date": dueDateCtrl.text,
        "height_cm": heightCtrl.text.isEmpty ? null : double.parse(heightCtrl.text),
        "previous_pregnancies": prevCtrl.text.isEmpty ? 0 : int.parse(prevCtrl.text),
        "existing_children": childCtrl.text.isEmpty ? 0 : int.parse(childCtrl.text),
      });

      setState(() => loading = false);

      if (success) {
        _showSuccess();
      } else {
        _showError("Signup failed. Email might already exist.");
      }
    } catch (e) {
      setState(() => loading = false);
      _showError("An error occurred. Please try again.");
    }
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Account created successfully!"),
        backgroundColor: AppColors.primary,
      ),
    );
    
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  Color _getPasswordBorderColor() {
    if (!passwordTouched && !confirmPasswordTouched) {
      return Colors.grey.shade300;
    }
    
    final password = passwordCtrl.text;
    final confirmPassword = confirmPasswordCtrl.text;
    
    if (password.isEmpty || confirmPassword.isEmpty) {
      return Colors.grey.shade300;
    }
    
    return passwordsMatch ? Colors.green : Colors.red;
  }

  String? _getPasswordMatchText() {
    if (!passwordTouched && !confirmPasswordTouched) {
      return null;
    }
    
    final password = passwordCtrl.text;
    final confirmPassword = confirmPasswordCtrl.text;
    
    if (password.isEmpty || confirmPassword.isEmpty) {
      return null;
    }
    
    return passwordsMatch ? "Passwords match" : "Passwords do not match";
  }

  Color _getPasswordMatchTextColor() {
    if (!passwordTouched && !confirmPasswordTouched) {
      return AppColors.textSecondary;
    }
    
    final password = passwordCtrl.text;
    final confirmPassword = confirmPasswordCtrl.text;
    
    if (password.isEmpty || confirmPassword.isEmpty) {
      return AppColors.textSecondary;
    }
    
    return passwordsMatch ? Colors.green : Colors.red;
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
                // Back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // App Icon Section
                Center(
                  child: Column(
                    children: [
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
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join your pregnancy journey with MommyAI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Required fields section
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Full Name
                _buildTextField(
                  controller: fullNameCtrl,
                  label: "Full Name",
                  icon: Icons.person,
                ),
                
                const SizedBox(height: 20),
                
                // Email
                _buildTextField(
                  controller: emailCtrl,
                  label: "Email Address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 20),
                
                // Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordCtrl,
                      obscureText: obscurePassword,
                      onChanged: (_) {
                        setState(() {
                          passwordTouched = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "At least 6 characters",
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Confirm Password with match indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmPasswordCtrl,
                      obscureText: obscureConfirmPassword,
                      onChanged: (_) {
                        setState(() {
                          confirmPasswordTouched = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Re-enter your password",
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getPasswordBorderColor(),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getPasswordBorderColor(),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _getPasswordBorderColor(),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    
                    // Password match indicator
                    if (_getPasswordMatchText() != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          children: [
                            Icon(
                              passwordsMatch ? Icons.check_circle : Icons.error,
                              size: 16,
                              color: _getPasswordMatchTextColor(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getPasswordMatchText()!,
                              style: TextStyle(
                                fontSize: 13,
                                color: _getPasswordMatchTextColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Pregnancy Information
                Text(
                  "Pregnancy Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Pregnancy Week
                _buildTextField(
                  controller: weekCtrl,
                  label: "Current Pregnancy Week",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  hintText: "e.g., 12",
                ),
                
                const SizedBox(height: 20),
                
                // Due Date with Calendar Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expected Due Date",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDueDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dueDateCtrl,
                          decoration: InputDecoration(
                            hintText: "Select date",
                            prefixIcon: Icon(Icons.event, color: AppColors.primary),
                            suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
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
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Optional fields section
                Text(
                  "Additional Information (Optional)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This helps us personalize your experience",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Height (moved to optional)
                _buildTextField(
                  controller: heightCtrl,
                  label: "Height (cm)",
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  optional: true,
                  hintText: "e.g., 165",
                ),
                
                const SizedBox(height: 20),
                
                // Previous Pregnancies
                _buildTextField(
                  controller: prevCtrl,
                  label: "Previous Pregnancies",
                  icon: Icons.child_care,
                  keyboardType: TextInputType.number,
                  optional: true,
                  hintText: "e.g., 2",
                ),
                
                const SizedBox(height: 20),
                
                // Existing Children
                _buildTextField(
                  controller: childCtrl,
                  label: "Existing Children",
                  icon: Icons.people,
                  keyboardType: TextInputType.number,
                  optional: true,
                  hintText: "e.g., 1",
                ),
                
                const SizedBox(height: 40),
                
                // Terms and Conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "By creating an account, you agree to our Terms of Service and Privacy Policy",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Signup button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _signup,
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
                            "Create Account",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Already have account section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: Text(
                            "Sign In",
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
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? hintText,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (optional)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  "(Optional)",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.primary),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}