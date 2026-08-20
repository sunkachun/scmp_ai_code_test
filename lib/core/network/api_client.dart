import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Map<String, String> _headers(Map<String, String>? extra) {
    final apiKey = dotenv.env['API_KEY'];
    return {
      if (apiKey != null && apiKey.isNotEmpty) 'x-api-key': apiKey,
      ...?extra,
    };
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client
        .post(Uri.parse(url), headers: _headers(headers), body: body)
        .timeout(timeout);
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) {
    return _client.get(Uri.parse(url), headers: _headers(headers)).timeout(timeout);
  }
}
