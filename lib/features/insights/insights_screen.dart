import 'package:flutter/material.dart';
import 'insights_service.dart';
import 'chat_service.dart';

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
    future = InsightsService().fetchInsights(1);
  }

  Future<void> sendChat() async {
    final question = chatController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": question});
      chatController.clear();
    });

    final reply = await ChatService().sendMessage(question, currentWeek);

    setState(() {
      messages.add({"sender": "bot", "text": reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Pregnancy Insights")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          currentWeek = data["week"] ?? 1;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _card("Week", data["week"].toString(), Colors.pink),
                    _card("Summary", data["summary"], Colors.blue),
                    _card("Risk", data["risk"].toString(), Colors.red),
                    _card("Trends", data["trends"].toString(), Colors.green),
                    _card("Recommendations",
                        (data["recommendations"] as List).join("\n• "),
                        Colors.purple),

                    const SizedBox(height: 20),
                    const Text("AI Chat Assistant",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),

                    ...messages.map((m) => _chatBubble(m["text"]!, m["sender"]!)),
                    const SizedBox(height: 80),
                  ],
                ),
              ),

              _chatInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _card(String title, String content, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.pinkAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              decoration: const InputDecoration(
                hintText: "Ask about pregnancy...",
                border: OutlineInputBorder(),
              ),
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
