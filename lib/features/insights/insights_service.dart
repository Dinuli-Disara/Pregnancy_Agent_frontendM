import 'dart:convert';
import 'package:http/http.dart' as http;
import 'insights_model.dart';

class InsightsService {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<Insight> fetchInsights(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/insights/$userId"),
    );

    if (response.statusCode == 200) {
      return Insight.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load insights");
    }
  }
}
