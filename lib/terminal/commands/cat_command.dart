import '../../services/file_manager.dart';

class CatCommand {
  static Future<String> execute(List<String> args) async {
    if (args.isEmpty) return '⚠️ Usage: cat <filename>';
    final content = await FileManager.loadFile(args[0]);
    return content.isNotEmpty
        ? '📄 ${args[0]}:\n$content'
        : '⚠️ File not found or empty.';
  }
}
