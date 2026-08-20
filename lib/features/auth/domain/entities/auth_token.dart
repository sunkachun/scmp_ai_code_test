import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  const AuthToken({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}
