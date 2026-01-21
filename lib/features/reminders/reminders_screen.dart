import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'reminder_model.dart';
import 'reminder_service.dart';


class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late Future<List<Reminder>> remindersFuture;

  @override
  void initState() {
    super.initState();
    remindersFuture = ReminderService.fetchReminders(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Reminders")),
      body: FutureBuilder<List<Reminder>>(
        future: remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading reminders"));
          }

          final reminders = snapshot.data!;

          if (reminders.isEmpty) {
            return const Center(child: Text("No reminders 🎉"));
          }

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final r = reminders[index];
              return Card(
                child: ListTile(
                  title: Text(r.title),
                  subtitle: Text(r.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      await ReminderService.markAsDone(r.id);
                      setState(() {
                        remindersFuture =
                            ReminderService.fetchReminders(1);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
