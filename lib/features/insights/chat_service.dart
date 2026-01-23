import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<String> sendMessage(int userId, String question) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "question": question,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data["answer"] ?? "Sorry, I couldn’t reply right now.").toString();
    } else {
      return "Sorry 💗 I’m having trouble responding right now.";
    }
  }
}
