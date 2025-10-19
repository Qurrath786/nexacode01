import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight.dart'; // Required for Mode
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart'; // ✅ Correct theme import
import 'package:nexacode/core/file_manager.dart';
import 'package:nexacode/core/language_service.dart';
import 'package:nexacode/widgets/glowing_background.dart';

class EditorScreen extends StatefulWidget {
  final String filename;
  const EditorScreen({required this.filename, super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late CodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CodeController(
      text: '',
      language: _getLanguage(LanguageService.getLanguage()),
    );
    _loadFile();
  }

  Mode _getLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'python':
        return python;
      case 'javascript':
        return javascript;
      default:
        return dart;
    }
  }

  Future<void> _saveFile() async {
    await FileManager.saveFile(widget.filename, _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ File saved')),
    );
  }

  Future<void> _loadFile() async {
    final content = await FileManager.loadFile(widget.filename);
    setState(() => _controller.text = content);
  }

  void _runCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ TerminalEngine not implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GlowingBackground()), // ✅ Wrapped for layout
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: Text(
              '📝 ${widget.filename} (${LanguageService.getLanguage()})',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                fontSize: 18,
                shadows: [Shadow(color: Colors.greenAccent, blurRadius: 8)],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.greenAccent),
                onPressed: _runCode,
              ),
              IconButton(
                icon: const Icon(Icons.save, color: Colors.greenAccent),
                onPressed: _saveFile,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: CodeField(
                controller: _controller,
                textStyle: const TextStyle(
                  fontFamily: 'FiraCode',
                  fontSize: 14,
                  color: Colors.greenAccent,
                ),
                expands: true,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
