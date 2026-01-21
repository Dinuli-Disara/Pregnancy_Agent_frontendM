import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reminder_model.dart';

class ReminderService {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  static Future<List<Reminder>> fetchReminders(int userId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/reminders/$userId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Reminder.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reminders');
    }
  }

  static Future<void> markAsDone(int reminderId) async {
    await http.post(
      Uri.parse('$_baseUrl/reminders/$reminderId/read'),
    );
  }
}
