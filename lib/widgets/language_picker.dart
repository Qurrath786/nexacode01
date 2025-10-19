import 'package:flutter/material.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '🌐 Language Picker Placeholder',
        style: TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'FiraCode',
        ),
      ),
    );
  }
}
