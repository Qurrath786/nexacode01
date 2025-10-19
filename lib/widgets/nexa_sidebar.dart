import 'package:flutter/material.dart';

class NexaSidebar extends StatelessWidget {
  const NexaSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(context, '🧠', '/terminal'),
          _buildButton(context, '📝', '/files'), // Editor opens via FileScreen
          _buildButton(context, '📁', '/files'),
          _buildButton(context, '⚙️', '/settings'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          icon,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.greenAccent,
            shadows: [Shadow(color: Colors.greenAccent, blurRadius: 6)],
          ),
        ),
      ),
    );
  }
}
