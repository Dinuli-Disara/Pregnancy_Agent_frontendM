import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<bool> signup(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("SIGNUP STATUS: ${response.statusCode}");
      print("SIGNUP BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("SIGNUP ERROR: $e");
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
