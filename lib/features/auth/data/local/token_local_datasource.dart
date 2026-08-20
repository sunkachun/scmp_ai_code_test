import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

class TokenLocalDataSource {
  String? _cachedToken;

  String? get currentToken => _cachedToken;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(AppConstants.tokenPrefsKey);
    return _cachedToken;
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenPrefsKey, token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenPrefsKey);
  }
}
