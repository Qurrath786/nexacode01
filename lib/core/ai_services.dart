import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  final String model = 'gpt-3.5-turbo';

  Future<String> getReply(String userInput) async {
    // If no API key, fallback to mock mode
    if (apiKey.isEmpty) {
      print("⚠️ OPENAI_API_KEY not found in .env");
      return _mockReply(userInput, reason: 'missing_key');
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': userInput},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      }

      if (response.statusCode == 429) {
        print("❌ API Error 429: Quota exceeded");
        return _mockReply(userInput, reason: 'quota_exceeded');
      }

      print("❌ API Error: ${response.statusCode}");
      print("❌ Response: ${response.body}");
      return _mockReply(userInput, reason: 'api_error');
    } catch (e) {
      print("❌ Exception: $e");
      return _mockReply(userInput, reason: 'exception');
    }
  }

  String _mockReply(String prompt, {String reason = 'offline'}) {
    switch (reason) {
      case 'missing_key':
        return '>> NexaBot: API key missing. Running in offline mode.';
      case 'quota_exceeded':
        return '>> NexaBot: ⚠️ Quota finished. Try again after recharge.';
      case 'api_error':
        return '>> NexaBot: Something went wrong with the request.';
      case 'exception':
        return '>> NexaBot: 🤖 Offline. But I still got jokes.';
      default:
        return _generateLocalReply(prompt);
    }
  }

  String _generateLocalReply(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('flutter')) {
      return '>> NexaBot: Flutter is Google’s UI toolkit for building beautiful apps.';
    }
    if (lower.contains('dart')) {
      return '>> NexaBot: Dart is the language behind Flutter. Fast, expressive, and typed.';
    }
    if (lower.contains('nexacode')) {
      return '>> NexaBot: NexaCode is your hacker’s OS. Modular, glowing, and built for coders.';
    }
    if (lower.contains('hello')) {
      return '>> NexaBot: Hello, Sonu. Ready to glow?';
    }
    return '>> NexaBot: I’m offline, but still alive. Ask me about Flutter, Dart, or NexaCode.';
  }
}
