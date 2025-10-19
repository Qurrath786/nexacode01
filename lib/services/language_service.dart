import 'dart:convert';
import 'package:flutter/services.dart';

class LanguageService {
  static Map<String, String> _localizedStrings = {};
  static String currentLanguage = 'en';

  /// Load language JSON file and update current language
  static Future<void> setLanguage(String languageCode) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/lang/$languageCode.json',
      );
      _localizedStrings = Map<String, String>.from(json.decode(jsonString));
      currentLanguage = languageCode;
    } catch (e) {
      print('Error loading language file: $e');
      _localizedStrings = {};
    }
  }

  /// Get translated string by key
  static String get(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// List of supported language codes
  static List<String> supportedLanguages = ['en', 'hi'];

  /// Get display name for language code
  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      default:
        return code;
    }
  }
}
