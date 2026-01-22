import 'dart:convert';
import 'package:http/http.dart' as http;

class InsightsService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>> fetchInsights(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/insights/$userId"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // SAFETY FIX
      return {
        "week": data["week"] ?? 0,
        "summary": data["summary"] ?? "No insight available",
        "risk": data["risk"] ?? {},
        "trends": data["trends"] ?? {},
        "recommendations": data["recommendations"] ?? [],
      };
    } else {
      throw Exception("Failed to load insights");
    }
  }
}
