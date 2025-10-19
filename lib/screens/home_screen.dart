import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _terminalLines = [
    '> Authenticated successfully',
    '> Loading NexaCode modules...',
    '> Ready.',
  ];
  final List<String> _displayedLines = [];
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Timer? _cursorTimer;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    _simulateBootSequence();
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _showCursor = !_showCursor);
    });
  }

  Future<void> _simulateBootSequence() async {
    for (final line in _terminalLines) {
      String current = '';
      for (int i = 0; i < line.length; i++) {
        await Future.delayed(const Duration(milliseconds: 30));
        current += line[i];

        if (_displayedLines.isEmpty || !_displayedLines.last.startsWith('>')) {
          _displayedLines.add(current);
        } else {
          _displayedLines[_displayedLines.length - 1] = current;
        }

        setState(() {});
        _scrollToBottom();
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (currentUser != null) {
      _displayedLines.add('> Welcome ${currentUser!.email}');
      setState(() {});
      _scrollToBottom();
    }
  }

  void _handleCommand(String input) {
    final command = input.trim().toLowerCase();
    if (command.isEmpty) return;

    setState(() => _displayedLines.add('> $command'));
    _scrollToBottom();

    switch (command) {
      case 'help':
        _displayedLines.add(
          'Available commands: help, logout, about, clear, whoami, dashboard',
        );
        break;
      case 'logout':
        _displayedLines.add('Logging out...');
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 'about':
        _displayedLines.add('NexaCode Terminal v1.0 — Flutter Web Edition');
        break;
      case 'clear':
        _displayedLines.clear();
        _simulateBootSequence();
        return;
      case 'whoami':
        final email = currentUser?.email ?? 'Unknown';
        _displayedLines.add('You are logged in as: $email');
        break;
      case 'dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      default:
        _displayedLines.add('Unknown command: "$command"');
    }

    _commandController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.greenAccent;
    final greenAlpha30 = green.withAlpha((0.3 * 255).round());
    final greenAlpha20 = green.withAlpha((0.2 * 255).round());
    final greenAlpha50 = green.withAlpha((0.5 * 255).round());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => _handleCommand('logout'),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/nexa_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0, 0, 0.6),
                        border: Border.all(color: greenAlpha30),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: greenAlpha20,
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _displayedLines.length,
                        itemBuilder: (context, index) {
                          final isLast = index == _displayedLines.length - 1;
                          final line = _displayedLines[index];
                          final showBlink = isLast && _showCursor;
                          return Text(
                            showBlink ? '$line|' : line,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.greenAccent,
                              fontFamily: 'FiraCode',
                              shadows: [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.greenAccent,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'nexacode@web:~\$ ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.greenAccent,
                          fontFamily: 'FiraCode',
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _commandController,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'FiraCode',
                          ),
                          cursorColor: Colors.greenAccent,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                            hintText: 'Type a command...',
                            hintStyle: TextStyle(color: greenAlpha50),
                          ),
                          onSubmitted: _handleCommand,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
