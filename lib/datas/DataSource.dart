import 'dart:convert';
import 'package:gpt_app/datas/message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getGptReply(String message, int id) async {
  final apikey = dotenv.env['API_KEY'];
  final apitogetherkey = dotenv.env['API_TOGETHER_KEY'];
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final url_together = Uri.parse(
    'https://api.together.xyz/v1/chat/completions',
  );
  final List<Map<String, dynamic>>? chat = await Message.instance.listMessages(
    id,
  );
  List<Map<String, String>> messages = [];

  if (chat != null && chat.isNotEmpty) {
    for (var data in chat) {
      messages.add({'role': data['role'], 'content': data['message']});
    }
  }

  messages.add({'role': 'user', 'content': message});

  final response = await http.post(
    url_together,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apitogetherkey',
    },
    body: jsonEncode({
      'model': 'deepseek-ai/DeepSeek-V3',
      'messages': messages,
      'max_tokens': 100,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'].trim();
  } else {
    return "Sorry, GPT is unavailable. Please check your API key or quota.";
  }
}
