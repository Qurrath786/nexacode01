import 'command_registry.dart';

Future<String> handleCommand(String input) async {
  final parts = input.trim().split(' ');
  final cmd = parts[0];
  final args = parts.sublist(1);

  final handler = commandMap[cmd];
  if (handler != null) {
    return await handler(args);
  } else {
    return '❌ Unknown command: "$input"';
  }
}
