import 'package:flutter/material.dart';
import 'package:nexacode/core/file_manager.dart';
import 'package:nexacode/screens/editor_screen.dart';
import 'package:nexacode/widgets/glowing_background.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  List<String> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final list = await FileManager.listFiles();
    setState(() => files = list);
  }

  void _openFile(String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditorScreen(filename: filename)),
    );
  }

  void _createFile() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          '📝 New File',
          style: TextStyle(color: Colors.greenAccent),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.greenAccent),
          decoration: const InputDecoration(
            hintText: 'Enter filename',
            hintStyle: TextStyle(color: Colors.greenAccent),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openFile(controller.text.trim());
            },
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GlowingBackground(),
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: const Text(
              '📁 Files',
              style: TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                fontSize: 18,
                shadows: [Shadow(color: Colors.greenAccent, blurRadius: 8)],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.greenAccent),
                onPressed: _createFile,
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: files.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(
                files[i],
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'FiraCode',
                ),
              ),
              onTap: () => _openFile(files[i]),
            ),
          ),
        ),
      ],
    );
  }
}
