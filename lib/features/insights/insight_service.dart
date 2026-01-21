import 'dart:convert';
import 'package:http/http.dart' as http;
import 'insight_model.dart';

class InsightService {
  static const _baseUrl = 'http://127.0.0.1:8000';

  static Future<Insight> fetchInsights(int userId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/insights/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Insight.fromJson(data);
    } else {
      throw Exception('Failed to load insights');
    }
  }
}
