import 'package:flutter/material.dart';
import 'dart:async';
import '../core/ai_services.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/pinned_drawer.dart';

class NexaBotScreen extends StatefulWidget {
  const NexaBotScreen({super.key});

  @override
  State<NexaBotScreen> createState() => _NexaBotScreenState();
}

class _NexaBotScreenState extends State<NexaBotScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final AIService aiService = AIService();

  List<Message> messages = [];
  List<Message> pinnedMessages = [];

  bool showCursor = true;
  bool isLoading = false;
  Timer? cursorTimer;

  final List<String> suggestions = [
    'explain async await',
    'generate regex for email',
    'summarize this code',
  ];

  @override
  void initState() {
    super.initState();
    cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
  }

  @override
  void dispose() {
    cursorTimer?.cancel();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleCommand(String input) async {
    final command = input.trim();
    if (command.isEmpty) return;

    _inputController.clear();
    setState(() {
      messages.add(Message(text: command, isUser: true));
      messages.add(Message(text: '>> Thinking...', isUser: false));
      isLoading = true;
    });

    _scrollToBottom();

    final reply = await aiService.getReply(command);

    setState(() {
      messages.removeLast(); // Remove "Thinking..."
      messages.add(Message(text: reply, isUser: false));
      isLoading = false;
    });

    _scrollToBottom();
  }

  void _togglePin(Message msg) {
    setState(() {
      msg.isPinned = !msg.isPinned;
      if (msg.isPinned) {
        pinnedMessages.add(msg);
        _showSnack('📌 Pinned message');
      } else {
        pinnedMessages.remove(msg);
        _showSnack('📍 Unpinned message');
      }
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: PinnedDrawer(pinnedMessages: pinnedMessages),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('🤖 NexaBot'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.push_pin),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'View pinned',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return MessageBubble(
                    message: msg,
                    onPin: () => _togglePin(msg),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (_) {},
              child: TextField(
                controller: _inputController,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'FiraCode',
                ),
                cursorColor: Colors.greenAccent,
                decoration: InputDecoration(
                  hintText: showCursor
                      ? 'nexabot@web:~\$ Ask something _'
                      : 'nexabot@web:~\$ Ask something  ',
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
              children: suggestions
                  .map(
                    (s) => GestureDetector(
                      onTap: () => _handleCommand(s),
                      child: Chip(
                        label: Text(
                          s,
                          style: const TextStyle(
                            fontFamily: 'FiraCode',
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
