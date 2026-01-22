import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/session/user_session.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<bool> signup(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body);
        UserSession.setFromJson(payload);
        return true;
      }

      print("SIGNUP FAIL: ${response.statusCode} ${response.body}");
      return false;
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

      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body);
        UserSession.setFromJson(payload);
        return true;
      }

      print("LOGIN FAIL: ${response.statusCode} ${response.body}");
      return false;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return false;
    }
  }
}
