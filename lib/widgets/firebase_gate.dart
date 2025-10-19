import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/terminal_login_screen.dart';
import '../screens/dashboard_screen.dart';

class FirebaseGate extends StatelessWidget {
  const FirebaseGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const TerminalLoginScreen(); // Show login if not signed in
    }

    return const DashboardScreen(); // Show dashboard if signed in
  }
}
