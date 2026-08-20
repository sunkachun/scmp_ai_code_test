import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scmp_ai_code_test/features/auth/data/local/token_local_datasource.dart';
import 'package:scmp_ai_code_test/features/auth/domain/entities/auth_token.dart';
import 'package:scmp_ai_code_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:scmp_ai_code_test/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:scmp_ai_code_test/features/auth/presentation/bloc/auth_event.dart';
import 'package:scmp_ai_code_test/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenLocalDataSource extends Mock implements TokenLocalDataSource {}

void main() {
  late MockAuthRepository authRepository;
  late MockTokenLocalDataSource tokenLocalDataSource;

  setUp(() {
    authRepository = MockAuthRepository();
    tokenLocalDataSource = MockTokenLocalDataSource();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] on successful login',
      build: () => AuthBloc(authRepository, tokenLocalDataSource),
      setUp: () {
        when(() => authRepository.login('eve.holt@reqres.in', 'cityslicka'))
            .thenAnswer((_) async => const AuthToken(token: 'token-123'));
        when(() => tokenLocalDataSource.saveToken('token-123'))
            .thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(
        const LoginSubmitted(
          email: 'eve.holt@reqres.in',
          password: 'cityslicka',
        ),
      ),
      expect: () => const [
        AuthLoading(),
        AuthSuccess('token-123'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] on failed login',
      build: () => AuthBloc(authRepository, tokenLocalDataSource),
      setUp: () {
        when(() => authRepository.login(any(), any()))
            .thenThrow(Exception('Invalid credentials'));
      },
      act: (bloc) => bloc.add(
        const LoginSubmitted(email: 'wrong@email.com', password: 'wrongpass'),
      ),
      expect: () => const [
        AuthLoading(),
        AuthFailure('Error: Invalid crdentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'clears token and emits AuthInitial on logout',
      build: () => AuthBloc(authRepository, tokenLocalDataSource),
      setUp: () {
        when(() => tokenLocalDataSource.clearToken()).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => const [AuthInitial()],
      verify: (_) {
        verify(() => tokenLocalDataSource.clearToken()).called(1);
      },
    );
  });
}
