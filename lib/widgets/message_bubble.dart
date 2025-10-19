import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback onPin;

  const MessageBubble({required this.message, required this.onPin, super.key});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    // ✅ Safe RGB extraction using .r, .g, .b
    final r = (Colors.greenAccent.r * 255.0).round() & 0xff;
    final g = (Colors.greenAccent.g * 255.0).round() & 0xff;
    final b = (Colors.greenAccent.b * 255.0).round() & 0xff;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(r, g, b, isUser ? 0.1 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'FiraCode',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onPin,
              child: Icon(
                message.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
