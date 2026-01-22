import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController ctrl = TextEditingController();
  final ChatService chat = ChatService();
  List<Map<String, String>> messages = [];

  void send() async {
    final text = ctrl.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add({"user": text});
      ctrl.clear();
    });

    final reply = await chat.sendMessage(text);

    setState(() {
      messages.add({"bot": reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: messages.map((m) {
              final isUser = m.containsKey("user");
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.pink.shade200 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(isUser ? m["user"]! : m["bot"]!),
                ),
              );
            }).toList(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                decoration: const InputDecoration(hintText: "Ask AI..."),
              ),
            ),
            IconButton(onPressed: send, icon: const Icon(Icons.send))
          ],
        )
      ],
    );
  }
}
