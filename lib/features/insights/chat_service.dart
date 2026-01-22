import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<String> sendMessage(String question, int week) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"question": question, "week": week}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["answer"];
    } else {
      return "Error contacting AI server";
    }
  }
}
