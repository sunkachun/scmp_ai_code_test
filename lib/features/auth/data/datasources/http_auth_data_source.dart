import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_token.dart';
import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

class HttpAuthDataSource implements AuthRemoteDataSource {
  HttpAuthDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthToken> login(String email, String password) async {
    final response = await _apiClient.post(
      '${AppConstants.baseUrl}${AppConstants.loginEndpoint}',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed with status ${response.statusCode}');
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponseModel.fromJson(json).toEntity();
    } catch (_) {
      throw Exception('Login failed: invalid response');
    }
  }
}
