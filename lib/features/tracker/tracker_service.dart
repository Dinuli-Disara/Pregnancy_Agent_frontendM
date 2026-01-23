import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackerService {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<bool> saveTracker({
    required int userId,
    required int waterGlasses,
    required double sleepHours,
    required int kicks,
    required List<String> symptoms,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/tracker/save"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "water_glasses": waterGlasses,
          "sleep_hours": sleepHours,
          "kicks": kicks,
          "symptoms": symptoms,
        }),
      );

      print("TRACKER STATUS: ${res.statusCode}");
      print("TRACKER BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      print("TRACKER ERROR: $e");
      return false;
    }
  }
}
