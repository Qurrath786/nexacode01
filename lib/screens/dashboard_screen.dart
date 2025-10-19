import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  final User? user;
  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _commandController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String feedback = '>> Welcome to NexaCode Terminal';
  bool showBoot = false;
  bool showCursor = true;

  List<String> commandHistory = [];
  int historyIndex = -1;

  List<String> suggestions = [
    'help',
    'clear',
    'setlang dart',
    'whoami',
    'logout',
  ];

  List<Map<String, dynamic>> modules = [
    {
      'label': 'Logout',
      'route': '/login',
      'icon': Icons.logout,
    },
    {
      'label': 'Settings',
      'route': '/settings',
      'icon': Icons.settings,
    },
    {
      'label': 'Files',
      'route': '/files',
      'icon': Icons.folder,
    },
    {
      'label': 'AI Chat',
      'route': '/chat',
      'icon': Icons.smart_toy,
    },
  ];

  Future<String> handleCommand(String input) async {
    commandHistory.insert(0, input);
    historyIndex = -1;

    final cmd = input.trim().toLowerCase();

    if (cmd == 'clear') return '';
    if (cmd == 'logout') {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
      return '>> Logged out.';
    }
    if (cmd.startsWith('setlang')) {
      final parts = input.split(' ');
      if (parts.length > 1) {
        return '>> Language set to ${parts[1]}';
      }
    }
    if (cmd == 'whoami') {
      return '>> ${widget.user?.email ?? 'Guest'}';
    }

    return '>> Command "$input" not recognized.';
  }

  void _handleCommand(String input) async {
    final output = await handleCommand(input);
    setState(() => feedback = output);
    _commandController.clear();
  }

  void _navigateHistory(bool up) {
    if (commandHistory.isEmpty) return;

    setState(() {
      historyIndex = up
          ? (historyIndex + 1).clamp(0, commandHistory.length - 1)
          : (historyIndex - 1).clamp(0, commandHistory.length - 1);

      _commandController.text = commandHistory[historyIndex];
      _commandController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commandController.text.length),
      );
    });
  }

  Widget _buildBootScreen() {
    return const Center(
      child: Text(
        '>> Booting NexaCode...',
        style: TextStyle(
          fontSize: 18,
          color: Colors.greenAccent,
          fontFamily: 'FiraCode',
          shadows: [Shadow(color: Colors.greenAccent, blurRadius: 12)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: showBoot
            ? _buildBootScreen()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.greenAccent,
                        fontFamily: 'FiraCode',
                        shadows: [Shadow(color: Colors.green, blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(height: 20),
                    KeyboardListener(
                      focusNode: _focusNode,
                      onKeyEvent: (event) {
                        if (event is KeyDownEvent) {
                          if (HardwareKeyboard.instance.isLogicalKeyPressed(
                              LogicalKeyboardKey.arrowUp)) {
                            _navigateHistory(true);
                          } else if (HardwareKeyboard.instance
                              .isLogicalKeyPressed(
                                  LogicalKeyboardKey.arrowDown)) {
                            _navigateHistory(false);
                          }
                        }
                      },
                      child: TextField(
                        controller: _commandController,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'FiraCode',
                        ),
                        cursorColor: Colors.greenAccent,
                        decoration: InputDecoration(
                          hintText: showCursor
                              ? 'nexacode@web:~\$ Type a command _'
                              : 'nexacode@web:~\$ Type a command',
                          hintStyle: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'FiraCode',
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                        onSubmitted: _handleCommand,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: suggestions.map((s) {
                        return ActionChip(
                          label: Text(
                            s,
                            style: const TextStyle(
                              fontFamily: 'FiraCode',
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.greenAccent,
                          onPressed: () => _handleCommand(s),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: modules.map((module) {
                        return GestureDetector(
                          onTap: () {
                            if (module['label'] == 'Logout') {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(
                                context,
                                module['route'],
                              );
                            } else {
                              Navigator.pushNamed(context, module['route']);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withAlpha(153),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  module['icon'],
                                  color: Colors.greenAccent,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  module['label'],
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'FiraCode',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
