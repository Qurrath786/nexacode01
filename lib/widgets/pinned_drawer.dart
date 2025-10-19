import 'package:flutter/material.dart';
import '../models/message.dart';

class PinnedDrawer extends StatelessWidget {
  final List<Message> pinnedMessages;

  const PinnedDrawer({required this.pinnedMessages, super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Extract RGB safely using .r, .g, .b
    final greenAccent = Colors.greenAccent;
    final r = (greenAccent.r * 255.0).round() & 0xff;
    final g = (greenAccent.g * 255.0).round() & 0xff;
    final b = (greenAccent.b * 255.0).round() & 0xff;

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "📌 Pinned Messages",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontFamily: 'FiraCode',
            ),
          ),
          const SizedBox(height: 12),
          ...pinnedMessages.map(
            (msg) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color.fromRGBO(r, g, b, 0.05),
                ),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'FiraCode',
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
