import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/token_local_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository, this._tokenLocalDataSource)
      : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;
  final TokenLocalDataSource _tokenLocalDataSource;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final token = await _authRepository.login(event.email, event.password);
      await _tokenLocalDataSource.saveToken(token.token);
      emit(AuthSuccess(token.token));
    } catch (_) {
      emit(const AuthFailure('Error: Invalid crdentials'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenLocalDataSource.clearToken();
    emit(const AuthInitial());
  }
}
