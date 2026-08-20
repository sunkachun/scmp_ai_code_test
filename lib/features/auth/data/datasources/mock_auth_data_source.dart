import '../../domain/entities/auth_token.dart';
import 'auth_remote_datasource.dart';

class MockAuthDataSource implements AuthRemoteDataSource {
  static const String validEmail = 'eve.holt@reqres.in';
  static const String validPassword = 'cityslicka';

  @override
  Future<AuthToken> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (email == validEmail && password == validPassword) {
      return const AuthToken(token: 'QpwL5tke4Pnpja7X4');
    }
    throw Exception('Invalid credentials');
  }
}
