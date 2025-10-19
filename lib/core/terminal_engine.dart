import 'package:nexacode/core/language_service.dart';

class TerminalEngine {
  static String run(String code) {
    final lang = LanguageService.getLanguage();
    return '[$lang] > Executing `$code`...\nOutput: Hello from $lang!';
  }
}
