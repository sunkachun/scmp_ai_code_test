import '../../domain/entities/auth_token.dart';

abstract class AuthRemoteDataSource {
  Future<AuthToken> login(String email, String password);
}
