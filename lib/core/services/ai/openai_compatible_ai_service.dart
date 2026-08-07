import 'dart:convert';
import 'dart:io';

import 'package:aetherdesk/core/services/ai/ai_service.dart';
import 'package:http/http.dart' as http;

/// Real [AiService] for any OpenAI-compatible `/chat/completions` HTTP API
/// (self-hosted Ollama/LM Studio, OpenRouter, or any other provider
/// speaking the same wire format) — [baseUrl]/[model]/[apiKey] come from
/// user-entered Settings, so no vendor is hardcoded.
class OpenAiCompatibleAiService implements AiService {
  OpenAiCompatibleAiService({
    required String baseUrl,
    required this.model,
    this.apiKey,
    http.Client? client,
  }) : baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl,
       _client = client ?? http.Client();

  final String baseUrl;
  final String model;
  final String? apiKey;
  final http.Client _client;

  Uri get _endpoint => Uri.parse('$baseUrl/chat/completions');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (apiKey != null && apiKey!.isNotEmpty) 'Authorization': 'Bearer $apiKey',
  };

  Map<String, dynamic> _requestBody(String prompt, {required bool stream}) => {
    'model': model,
    'messages': [
      {'role': 'user', 'content': prompt},
    ],
    'stream': stream,
  };

  @override
  Future<String> generateText(String prompt) async {
    final response = await _client.post(
      _endpoint,
      headers: _headers,
      body: jsonEncode(_requestBody(prompt, stream: false)),
    );
    if (response.statusCode != 200) {
      throw HttpException(
        'AI endpoint returned ${response.statusCode}: ${response.body}',
      );
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return _extractContent(decoded, messageKey: 'message') ?? '';
  }

  @override
  Stream<String> streamResponse(String prompt) async* {
    final request = http.Request('POST', _endpoint)
      ..headers.addAll(_headers)
      ..body = jsonEncode(_requestBody(prompt, stream: true));
    final streamedResponse = await _client.send(request);
    if (streamedResponse.statusCode != 200) {
      final body = await streamedResponse.stream.bytesToString();
      throw HttpException(
        'AI endpoint returned ${streamedResponse.statusCode}: $body',
      );
    }
    final lines = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;
      final payload = line.substring(6).trim();
      if (payload.isEmpty || payload == '[DONE]') continue;
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final chunk = _extractContent(decoded, messageKey: 'delta');
      if (chunk != null && chunk.isNotEmpty) yield chunk;
    }
  }

  String? _extractContent(
    Map<String, dynamic> decoded, {
    required String messageKey,
  }) {
    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;
    final message =
        (choices.first as Map<String, dynamic>)[messageKey]
            as Map<String, dynamic>?;
    return message?['content'] as String?;
  }
}
