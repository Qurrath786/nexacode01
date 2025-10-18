import '../../services/file_manager.dart';

class SaveCommand {
  static Future<String> execute(List<String> args) async {
    if (args.length < 2) return '⚠️ Usage: save <filename> <content>';
    final filename = args[0];
    final content = args.sublist(1).join(' ');
    await FileManager.saveFile(filename, content);
    return '✅ Saved "$filename"';
  }
}
