import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scmp_ai_code_test/features/staff/data/datasources/staff_remote_datasource.dart';
import 'package:scmp_ai_code_test/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:scmp_ai_code_test/features/staff/domain/entities/user.dart';
import 'package:scmp_ai_code_test/features/staff/domain/entities/user_page.dart';

class MockStaffRemoteDataSource extends Mock implements StaffRemoteDataSource {}

void main() {
  late MockStaffRemoteDataSource dataSource;
  late StaffRepositoryImpl repository;

  setUp(() {
    dataSource = MockStaffRemoteDataSource();
    repository = StaffRepositoryImpl(dataSource);
  });

  test('getUsers returns UserPage on success', () async {
    const user = User(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatar: 'https://reqres.in/img/faces/1-image.jpg',
    );
    const page = UserPage(
      users: [user],
      currentPage: 1,
      totalPages: 2,
      hasMore: true,
    );
    when(() => dataSource.getUsers(1)).thenAnswer((_) async => page);

    final result = await repository.getUsers(1);

    expect(result, page);
    verify(() => dataSource.getUsers(1)).called(1);
  });

  test('getUsers throws Exception when datasource fails', () async {
    when(() => dataSource.getUsers(any()))
        .thenThrow(Exception('Failed to load users'));

    expect(() => repository.getUsers(1), throwsA(isA<Exception>()));
  });
}
