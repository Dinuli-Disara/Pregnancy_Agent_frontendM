import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (Mapped to DB fields)
  final TextEditingController fullNameController =
      TextEditingController(text: "Arunodya Janadari");
  final TextEditingController emailController =
      TextEditingController(text: "user@email.com");
  final TextEditingController phoneController =
      TextEditingController(text: "0771234567");
  final TextEditingController dobController =
      TextEditingController(text: "2002-05-10");
  final TextEditingController heightController =
      TextEditingController(text: "160");
  final TextEditingController childrenController =
      TextEditingController(text: "0");
  final TextEditingController pregnanciesController =
      TextEditingController(text: "1");

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit,
                color: AppColors.primary),
            onPressed: () {
              if (isEditing && _formKey.currentState!.validate()) {
                // Later → send data to backend
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile updated")),
                );
              }
              setState(() {
                isEditing = !isEditing;
              });
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

              /// PERSONAL INFO
              sectionTitle("Personal Information"),

              profileField("Full Name", fullNameController),
              profileField("Email", emailController, enabled: false),
              profileField("Phone", phoneController),
              profileField("Date of Birth", dobController),
              profileField("Height (cm)", heightController,
                  keyboard: TextInputType.number),

              const SizedBox(height: 25),

              /// PREGNANCY INFO
              sectionTitle("Pregnancy Information"),

              readOnlyCard("Current Week", "24 weeks"),
              readOnlyCard("Expected Due Date", "2025-03-15"),

              profileField("Previous Pregnancies",
                  pregnanciesController,
                  keyboard: TextInputType.number),

              profileField("Existing Children",
                  childrenController,
                  keyboard: TextInputType.number),

              const SizedBox(height: 30),

              /// LOGOUT
              ElevatedButton.icon(
                onPressed: () {
                  // Later → Clear token & navigate to login
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

  /// REUSABLE WIDGETS

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
          fillColor: enabled
              ? Colors.grey.shade100
              : Colors.grey.shade200,
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
          Text(title,
              style: TextStyle(color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}
