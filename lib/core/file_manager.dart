import 'dart:async';

class FileManager {
  static final List<String> _mockFiles = [
    'main.dart',
    'README.md',
    'notes.txt',
    'config.json',
  ];

  static Future<List<String>> listFiles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockFiles);
  }

  static Future<void> deleteFile(String filename) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockFiles.remove(filename);
    print('>> Deleted: $filename');
  }

  static Future<void> saveFile(String filename, String content) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_mockFiles.contains(filename)) {
      _mockFiles.add(filename);
    }
    print('>> Saved: $filename');
  }

  static Future<String> readFile(String filename) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return '// Contents of $filename\nvoid main() => print("Hello NexaCode");';
  }
}
