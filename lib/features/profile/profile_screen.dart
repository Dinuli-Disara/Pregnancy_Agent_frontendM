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
          const SnackBar(content: Text("Profile updated")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit,
                color: AppColors.primary),
            onPressed: () async {
              if (isEditing) {
                await _saveProfile();
              }
              setState(() => isEditing = !isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Personal Information"),
              profileField("Full Name", fullNameController),
              profileField("Email", emailController, enabled: false),
              profileField("Phone", phoneController),
              profileField("Date of Birth (YYYY-MM-DD)", dobController),
              profileField("Height (cm)", heightController,
                  keyboard: TextInputType.number),

              const SizedBox(height: 25),

              sectionTitle("Pregnancy Information"),
              readOnlyCard("Current Week", currentWeekText == "-" ? "-" : "$currentWeekText weeks"),
              readOnlyCard("Expected Due Date", dueDateText),

              profileField("Previous Pregnancies", pregnanciesController,
                  keyboard: TextInputType.number),
              profileField("Existing Children", childrenController,
                  keyboard: TextInputType.number),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  // you can later clear session + navigate login
                  UserSession.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) =>false,
                  );
                },

                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI helpers
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget profileField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        enabled: isEditing && enabled,
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: enabled ? Colors.grey.shade100 : Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget readOnlyCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}
