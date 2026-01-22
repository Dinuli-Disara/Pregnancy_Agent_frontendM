import 'package:shared_preferences/shared_preferences.dart';
class UserSession {
  static int? userId;
  static String? fullName;
  static String? email;

  static double? heightCm;
  static int? pregnancyWeek;
  static String? expectedDueDate;

  static int? previousPregnancies;
  static int? existingChildren;

  static void setFromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    fullName = json["full_name"];
    email = json["email"];

    heightCm = (json["height_cm"] == null) ? null : double.tryParse(json["height_cm"].toString());
    pregnancyWeek = json["pregnancy_week"];
    expectedDueDate = json["expected_due_date"];

    previousPregnancies = json["previous_pregnancies"];
    existingChildren = json["existing_children"];
  }

  static void clear() {
    userId = null;
    fullName = null;
    email = null;
    heightCm = null;
    pregnancyWeek = null;
    expectedDueDate = null;
    previousPregnancies = null;
    existingChildren = null;
  }
}

