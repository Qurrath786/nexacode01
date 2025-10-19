import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/terminal_login_screen.dart';
import 'screens/dashboard_screen.dart';

import 'firebase_options.dart';
import 'services/language_service.dart';
import 'services/locale_manager.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('>> Flutter error: ${details.exception}');
  };

  try {
    print('>> Loading .env...');
    //await dotenv.load(fileName: '.env');
    print('>> .env loaded');
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print('>> WARNING: OPENAI_API_KEY is missing or empty');
    } else {
      print('>> API KEY: $apiKey');
    }
  } catch (e) {
    print('>> .env load error: $e');
  }

  try {
    print('>> Initializing Firebase...');
    //await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
    //);
    print('>> Firebase initialized');
  } catch (e) {
    print('>> Firebase init error: $e');
    runApp(const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '>> Firebase failed to initialize',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    ));
    return;
  }

  final langCode = await LocaleManager.loadLanguage();
  await LanguageService.setLanguage(langCode);

  print('>> Running NexaCodeApp...');
  runApp(NexaCodeApp(langCode: langCode));
}

class NexaCodeApp extends StatelessWidget {
  final String langCode;
  const NexaCodeApp({super.key, required this.langCode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexaCode',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      locale: Locale(langCode),
      supportedLocales: const [Locale('en'), Locale('hi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      routes: {
        '/home': (context) =>
            DashboardScreen(user: FirebaseAuth.instance.currentUser),
        '/login': (context) => const TerminalLoginScreen(),
      },
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                '>> Error: ${details.exception}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        };
        return child ??
            const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  '>> Unexpected error: No widget tree',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            );
      },
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '>> NexaCode is alive!',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
      ),
    );
  }
}
