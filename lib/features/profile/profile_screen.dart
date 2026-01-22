import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../shared/session/user_session.dart';
import 'profile_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();
  final TextEditingController pregnanciesController = TextEditingController();

  bool isEditing = false;
  bool loading = true;
  String currentWeekText = "-";
  String dueDateText = "-";
  DateTime? selectedDob;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = UserSession.userId;
    if (userId == null) {
      setState(() => loading = false);
      return;
    }

    try {
      final data = await ProfileService().getProfile(userId);

      fullNameController.text = (data["full_name"] ?? "").toString();
      emailController.text = (data["email"] ?? "").toString();
      phoneController.text = (data["phone"] ?? "").toString();
      dobController.text = (data["date_of_birth"] ?? "").toString();
      heightController.text = (data["height_cm"] ?? "").toString();
      childrenController.text = (data["existing_children"] ?? "0").toString();
      pregnanciesController.text =
          (data["previous_pregnancies"] ?? "0").toString();

      // optional fields (if your backend returns them)
      currentWeekText = (data["current_week"] ?? "-").toString();
      dueDateText = (data["expected_due_date"] ?? "-").toString();

      // Parse date of birth for calendar picker
      if (dobController.text.isNotEmpty) {
        try {
          final parts = dobController.text.split('-');
          if (parts.length == 3) {
            selectedDob = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
          }
        } catch (e) {
          // Date format error, ignore
        }
      }

      // keep welcome name updated in session too
      if (fullNameController.text.isNotEmpty) {
        UserSession.fullName = fullNameController.text;
      }

    } catch (e) {
      // if backend not ready, at least show session name/email
      fullNameController.text = UserSession.fullName ?? "";
      emailController.text = UserSession.email ?? "";
    }

    setState(() => loading = false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        selectedDob = picked;
        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = UserSession.userId;
    if (userId == null) return;

    final payload = {
      "full_name": fullNameController.text.trim(),
      "phone": phoneController.text.trim(),
      "date_of_birth": dobController.text.trim(), // "YYYY-MM-DD"
      "height_cm": double.tryParse(heightController.text.trim()) ?? 0,
      "existing_children": int.tryParse(childrenController.text.trim()) ?? 0,
      "previous_pregnancies": int.tryParse(pregnanciesController.text.trim()) ?? 0,
    };

    try {
      await ProfileService().updateProfile(userId, payload);

      UserSession.fullName = payload["full_name"] as String;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Update failed: ${e.toString()}"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Logout",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              UserSession.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        color: AppColors.primary,
                      ),
                      onPressed: () async {
                        if (isEditing) {
                          await _saveProfile();
                        }
                        setState(() => isEditing = !isEditing);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Profile Icon Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        fullNameController.text.isNotEmpty 
                            ? fullNameController.text 
                            : "Your Name",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        emailController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      sectionTitle("Personal Information"),
                      
                      _buildTextField(
                        label: "Full Name",
                        controller: fullNameController,
                        icon: Icons.person,
                        enabled: isEditing,
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: "Email Address",
                        controller: emailController,
                        icon: Icons.email,
                        enabled: false, // Email should not be editable
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: "Phone Number",
                        controller: phoneController,
                        icon: Icons.phone,
                        enabled: isEditing,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      // Date of Birth with Calendar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: isEditing ? () => _selectDate(context) : null,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: dobController,
                                enabled: isEditing,
                                decoration: InputDecoration(
                                  hintText: "YYYY-MM-DD",
                                  prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                                  suffixIcon: isEditing 
                                    ? Icon(Icons.calendar_month, color: AppColors.primary)
                                    : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                  filled: !isEditing,
                                  fillColor: !isEditing ? AppColors.blue.withOpacity(0.1) : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: "Height (cm)",
                        controller: heightController,
                        icon: Icons.height,
                        enabled: isEditing,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 30),

                      // Pregnancy Information Section
                      sectionTitle("Pregnancy Information"),
                      
                      _buildReadOnlyCard(
                        title: "Current Pregnancy Week",
                        value: currentWeekText == "-" ? "Not set" : "$currentWeekText weeks",
                        icon: Icons.calendar_today,
                      ),

                      const SizedBox(height: 16),

                      _buildReadOnlyCard(
                        title: "Expected Due Date",
                        value: dueDateText == "-" ? "Not set" : dueDateText,
                        icon: Icons.event,
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: "Previous Pregnancies",
                        controller: pregnanciesController,
                        icon: Icons.child_care,
                        enabled: isEditing,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: "Existing Children",
                        controller: childrenController,
                        icon: Icons.people,
                        enabled: isEditing,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 40),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue, width: 2),
            ),
            filled: !enabled,
            fillColor: !enabled ? AppColors.blue.withOpacity(0.1) : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}