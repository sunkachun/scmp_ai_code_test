import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scmp_ai_code_test/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:scmp_ai_code_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:scmp_ai_code_test/features/auth/domain/entities/auth_token.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  test('login returns AuthToken on success', () async {
    const token = AuthToken(token: 'QpwL5tke4Pnpja7X4');
    when(() => dataSource.login('eve.holt@reqres.in', 'cityslicka'))
        .thenAnswer((_) async => token);

    final result = await repository.login('eve.holt@reqres.in', 'cityslicka');

    expect(result, token);
    verify(() => dataSource.login('eve.holt@reqres.in', 'cityslicka'))
        .called(1);
  });

  test('login throws Exception when datasource fails', () async {
    when(() => dataSource.login(any(), any()))
        .thenThrow(Exception('Invalid credentials'));

    expect(
      () => repository.login('wrong@email.com', 'wrongpass'),
      throwsA(isA<Exception>()),
    );
  });
}
