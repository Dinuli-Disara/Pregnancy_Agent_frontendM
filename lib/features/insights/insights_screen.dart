import 'package:flutter/material.dart';
import 'insights_service.dart';
import 'chat_service.dart';
import '../../shared/session/user_session.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<Map<String, dynamic>> future;
  final chatController = TextEditingController();
  final List<Map<String, String>> messages = [];

  int currentWeek = 1;

  @override
  void initState() {
    super.initState();
    final userId = UserSession.userId ?? 1; // fallback for testing
    future = InsightsService().fetchInsights(userId);

    // Friendly starter message
    final name = UserSession.fullName ?? "Mom";
    messages.add({
      "sender": "bot",
      "text": "Hi $name 💗 How are you feeling today?"
    });
  }

  Future<void> sendChat() async {
    final question = chatController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": question});
      chatController.clear();
    });

    try {
      final reply = await ChatService().sendMessage(1, question); // TEMP user id

      setState(() {
        messages.add({"sender": "bot", "text": reply});
      });
    } catch (_) {
      setState(() {
        messages.add({
          "sender": "bot",
          "text": "I’m here with you 💗 I had a small issue. Please try again."
        });
      });
    }
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = UserSession.fullName ?? "Mom";

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Pregnancy Insights"),
        backgroundColor: Colors.pink.shade300,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? {};
          currentWeek = (data["week"] ?? 1) as int;

          final summary = (data["summary"] ?? "No insight available").toString();
          final risk = (data["risk"] ?? {}) as Map;
          final trends = (data["trends"] ?? {}) as Map;
          final recs = (data["recommendations"] ?? []) as List;

          return Column(
            children: [
              // Insights area
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    // Greeting
                    Text(
                      "Hi $name 💗",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Here’s your AI insight for today (Week $currentWeek).",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),

                    _card("Week", "$currentWeek", Colors.pink),
                    _card("Summary", summary, Colors.blue),

                    _card(
                      "Risk",
                      "Dehydration: ${risk["dehydration"] ?? "Low"}\n"
                      "Fatigue: ${risk["fatigue"] ?? "Low"}",
                      Colors.red,
                    ),

                    _card(
                      "Trends",
                      "Hydration: ${trends["hydration"] ?? "Stable"}\n"
                      "Sleep: ${trends["sleep"] ?? "Stable"}\n"
                      "Baby Movement: ${trends["baby_movement"] ?? "Normal"}",
                      Colors.green,
                    ),

                    _card(
                      "Recommendations",
                      recs.isEmpty ? "No recommendations yet." : "• ${recs.join("\n• ")}",
                      Colors.purple,
                    ),

                    const SizedBox(height: 18),
                    const Text(
                      "AI Chat Assistant",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    ...messages.map((m) => _chatBubble(m["text"]!, m["sender"]!)),
                    const SizedBox(height: 90),
                  ],
                ),
              ),

              // chat input
              _chatInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _card(String title, String content, Color color) {
    return Card(
      color: color.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _chatBubble(String text, String sender) {
    final isUser = sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.pinkAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              decoration: InputDecoration(
                hintText: "Ask about pregnancy...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onSubmitted: (_) => sendChat(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pink),
            onPressed: sendChat,
          ),
        ],
      ),
    );
  }
}
