import '../../domain/entities/auth_token.dart';

class LoginResponseModel {
  const LoginResponseModel({required this.token});

  final String token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(token: json['token'] as String);

  AuthToken toEntity() => AuthToken(token: token);
}
