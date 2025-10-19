import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          '❌ Anonymous sign-in failed',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 24,
            fontFamily: 'FiraCode',
            shadows: [Shadow(color: Colors.redAccent, blurRadius: 12)],
          ),
        ),
      ),
    );
  }
}
