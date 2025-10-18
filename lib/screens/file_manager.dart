import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<void> saveFile(String filename, String content) async {
    final path = await _getDirPath();
    final file = File('$path/$filename');
    await file.writeAsString(content);
  }

  static Future<String> loadFile(String filename) async {
    final path = await _getDirPath();
    final file = File('$path/$filename');
    return file.existsSync() ? await file.readAsString() : '';
  }

  static Future<List<String>> listFiles() async {
    final path = await _getDirPath();
    final dir = Directory(path);
    final files = dir.listSync().whereType<File>();
    return files.map((f) => f.path.split('/').last).toList();
  }
}
