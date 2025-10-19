import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/pinned_drawer.dart';
import '../core/ai_services.dart'; // ✅ Import AIService

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  final TextEditingController controller = TextEditingController();
  final AIService _aiService = AIService(); // ✅ Instantiate AIService

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(Message(text: text, isUser: true));
    });
    controller.clear();

    final reply = await _aiService.getReply(text); // ✅ Get AI reply
    setState(() {
      messages.add(Message(text: reply, isUser: false));
    });
  }

  void togglePin(int index) {
    setState(() {
      messages[index].isPinned = !messages[index].isPinned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pinned = messages.where((msg) => msg.isPinned).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: PinnedDrawer(pinnedMessages: pinned),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "NexaBot",
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'FiraCode',
            fontSize: 20,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.push_pin, color: Colors.greenAccent),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (_, i) => MessageBubble(
                message: messages[i],
                onPin: () => togglePin(i),
              ),
            ),
          ),
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'FiraCode',
                    ),
                    decoration: InputDecoration(
                      hintText: "Type a command...",
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontFamily: 'FiraCode',
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
