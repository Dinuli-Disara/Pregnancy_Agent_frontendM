class Reminder {
  final int id;
  final String type;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.isCompleted,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      type: json['notification_type'],
      title: json['title'],
      description: json['message'],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      isCompleted: json['is_read'] == true,
    );
  }
}
