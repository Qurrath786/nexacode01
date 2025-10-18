import '../../services/file_manager.dart';

class LsCommand {
  static Future<String> execute(List<String> args) async {
    final files = await FileManager.listFiles();
    return files.isNotEmpty
        ? '📁 Files:\n' + files.join('\n')
        : '📂 No files found.';
  }
}
