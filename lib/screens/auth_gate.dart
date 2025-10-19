import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';
import 'terminal_login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    print("AuthGate: building...");

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("AuthGate: connectionState = ${snapshot.connectionState}");
        print("AuthGate: hasData = ${snapshot.hasData}");
        print("AuthGate: error = ${snapshot.error}");

        if (snapshot.hasError) {
          print("AuthGate: ERROR = ${snapshot.error}");
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "❌ Firebase Auth error",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("AuthGate: waiting for Firebase...");
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
          );
        }

        if (snapshot.hasData) {
          print("AuthGate: user is logged in");
          return const DashboardScreen();
        } else {
          print("AuthGate: user is NOT logged in");
          return const TerminalLoginScreen();
        }
      },
    );
  }
}
