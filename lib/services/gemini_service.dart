import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyBjgQFm9_YMLU0AWOLVMVKI3fA6DByJ2Kc';

  static Future<String> generateAnswer(String question) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$apiKey',
    );

    final payload = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  question +
                  "\n\nAnswer in short. Don't bold any text or style:",
            },
          ],
        },
      ],
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final text = decoded["candidates"]?[0]["content"]["parts"][0]["text"];
      return text ?? "No response.";
    } else {
      print(response.body); // log full error
      return "Error: ${response.body}";
    }
  }
}
