import 'package:flutter/material.dart';
import 'dart:async';
import 'terminal_login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> bootLines = [
    ">> Initializing NexaCore modules...",
    ">> Loading auth_gate.dart",
    ">> Loading terminal_login_screen.dart",
    ">> Establishing secure channel...",
    ">> Ready.",
  ];

  final List<String> displayedLines = [];
  int currentLine = 0;
  bool showCursor = true;
  late Timer cursorTimer;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (currentLine < bootLines.length) {
        setState(() {
          displayedLines.add(bootLines[currentLine]);
          currentLine++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const TerminalLoginScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        });
      }
    });

    cursorTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
  }

  @override
  void dispose() {
    cursorTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '''
 _   _ ________  ___   _____          _      
| \\ | |  ___|  \\/  | |_   _|__   ___ | | ___ 
|  \\| | |_  | |\\/| |   | |/ _ \\ / _ \\| |/ _ \\
| |\\  |  _| | |  | |   | | (_) | (_) | |  __/
\\_| \\_/_|   \\_|  |_/   |_|\\___/ \\___/|_|\\___|
              ''',
              style: TextStyle(
                fontSize: 12,
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                height: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            ...displayedLines.map(
              (line) => Text(
                line,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontFamily: 'FiraCode',
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.greenAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            if (currentLine == bootLines.length)
              Text(
                showCursor ? ">> Ready._" : ">> Ready. ",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontFamily: 'FiraCode',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
