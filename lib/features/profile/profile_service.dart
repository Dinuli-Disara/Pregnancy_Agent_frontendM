import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  static const baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>> getProfile(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/users/$userId"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception("Failed to load profile: ${res.statusCode} ${res.body}");
  }

  Future<void> updateProfile(int userId, Map<String, dynamic> payload) async {
    final res = await http.put(
      Uri.parse("$baseUrl/users/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to update profile: ${res.statusCode} ${res.body}");
    }
  }
}
