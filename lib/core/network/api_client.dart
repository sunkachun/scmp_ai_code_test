import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.post(Uri.parse(url), headers: headers, body: body);
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) {
    return _client.get(Uri.parse(url), headers: headers);
  }
}
