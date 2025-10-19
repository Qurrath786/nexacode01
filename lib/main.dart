import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/terminal_login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/user_screen.dart';
import 'screens/file_screen.dart'; // ✅ Make sure this import exists
import 'screens/nexabot_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('>> MAIN STARTED');
  runApp(const NexaCodeApp());
}

class NexaCodeApp extends StatelessWidget {
  const NexaCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexaCode Terminal',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent),
        ),
      ),
      home: const TerminalLoginScreen(),
      routes: {
        '/home': (context) => const DashboardScreen(),
        '/User': (context) => const UserScreen(),
        '/files': (context) =>
            const FileScreen(), // ✅ This must match the class name
        '/chat': (context) => const NexaBotScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/login': (context) => const TerminalLoginScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const TerminalLoginScreen(),
      ),
    );
  }
}
