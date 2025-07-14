import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getGptReply(String message) async {
  final apikey = dotenv.env['API_KEY'];
  final apitogetherkey = dotenv.env['API_TOGETHER_KEY'];
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final url_together = Uri.parse(
    'https://api.together.xyz/v1/chat/completions',
  );

  final response = await http.post(
    url_together,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apitogetherkey',
    },
    body: jsonEncode({
      'model': 'deepseek-ai/DeepSeek-V3',
      'messages': [
        // {'role': 'system', 'content': 'you are a helpful assistant'},
        {'role': 'user', 'content': message},
      ],
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
