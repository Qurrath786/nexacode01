import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  final List<String> logs = const [
    '>> [2025-08-09 18:42] ✅ Login successful',
    '>> [2025-08-09 18:43] ✅ Dashboard loaded',
    '>> [2025-08-09 18:44] ⚠️ No errors detected',
    '>> [2025-08-09 18:45] ✅ Command: open settings',
    '>> [2025-08-09 18:46] ✅ Command: show logs',
    '>> [2025-08-09 18:47] ✅ Module launched: Logs',
    '>> [2025-08-09 18:48] ⚠️ Logout attempt cancelled',
    '>> [2025-08-09 18:49] ✅ Command: glow test',
    '>> [2025-08-09 18:50] ✅ UI render complete',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: const Text(
          'NexaLogs',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'FiraCode',
            fontSize: 20,
            shadows: [Shadow(color: Colors.greenAccent, blurRadius: 8)],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '>> System Logs',
              style: TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                shadows: [Shadow(color: Colors.green, blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      logs[index],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.greenAccent,
                        fontFamily: 'FiraCode',
                        shadows: [Shadow(color: Colors.green, blurRadius: 6)],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
