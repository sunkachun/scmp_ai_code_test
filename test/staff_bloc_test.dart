import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scmp_ai_code_test/features/auth/data/local/token_local_datasource.dart';
import 'package:scmp_ai_code_test/features/staff/domain/entities/user.dart';
import 'package:scmp_ai_code_test/features/staff/domain/entities/user_page.dart';
import 'package:scmp_ai_code_test/features/staff/domain/repositories/staff_repository.dart';
import 'package:scmp_ai_code_test/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:scmp_ai_code_test/features/staff/presentation/bloc/staff_event.dart';
import 'package:scmp_ai_code_test/features/staff/presentation/bloc/staff_state.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

class MockTokenLocalDataSource extends Mock implements TokenLocalDataSource {}

const _user1 = User(
  id: 1,
  email: 'george.bluth@reqres.in',
  firstName: 'George',
  lastName: 'Bluth',
  avatar: 'https://reqres.in/img/faces/1-image.jpg',
);
const _user2 = User(
  id: 2,
  email: 'janet.weaver@reqres.in',
  firstName: 'Janet',
  lastName: 'Weaver',
  avatar: 'https://reqres.in/img/faces/2-image.jpg',
);
const _user3 = User(
  id: 7,
  email: 'michael.lawson@reqres.in',
  firstName: 'Michael',
  lastName: 'Lawson',
  avatar: 'https://reqres.in/img/faces/7-image.jpg',
);

void main() {
  late MockStaffRepository staffRepository;
  late MockTokenLocalDataSource tokenLocalDataSource;

  setUp(() {
    staffRepository = MockStaffRepository();
    tokenLocalDataSource = MockTokenLocalDataSource();
  });

  group('StaffBloc', () {
    blocTest<StaffBloc, StaffState>(
      'FetchStaffList emits loading then loaded list with token',
      build: () => StaffBloc(staffRepository, tokenLocalDataSource),
      setUp: () {
        when(() => tokenLocalDataSource.getToken())
            .thenAnswer((_) async => 'token-abc');
        when(() => staffRepository.getUsers(1)).thenAnswer(
          (_) async => const UserPage(
            users: [_user1, _user2],
            currentPage: 1,
            totalPages: 2,
            hasMore: true,
          ),
        );
      },
      act: (bloc) => bloc.add(const FetchStaffList()),
      expect: () => const [
        StaffLoading(),
        StaffLoaded(
          users: [_user1, _user2],
          token: 'token-abc',
          hasMore: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<StaffBloc, StaffState>(
      'FetchNextPage appends the next page to the existing list',
      build: () => StaffBloc(staffRepository, tokenLocalDataSource),
      setUp: () {
        when(() => tokenLocalDataSource.getToken())
            .thenAnswer((_) async => 'token-abc');
        when(() => staffRepository.getUsers(1)).thenAnswer(
          (_) async => const UserPage(
            users: [_user1, _user2],
            currentPage: 1,
            totalPages: 2,
            hasMore: true,
          ),
        );
        when(() => staffRepository.getUsers(2)).thenAnswer(
          (_) async => const UserPage(
            users: [_user3],
            currentPage: 2,
            totalPages: 2,
            hasMore: false,
          ),
        );
      },
      act: (bloc) async {
        bloc.add(const FetchStaffList());
        await bloc.stream.firstWhere((state) => state is StaffLoaded);
        bloc.add(const FetchNextPage());
      },
      expect: () => [
        const StaffLoading(),
        const StaffLoaded(
          users: [_user1, _user2],
          token: 'token-abc',
          hasMore: true,
          isLoadingMore: false,
        ),
        const StaffLoaded(
          users: [_user1, _user2],
          token: 'token-abc',
          hasMore: true,
          isLoadingMore: true,
        ),
        const StaffLoaded(
          users: [_user1, _user2, _user3],
          token: 'token-abc',
          hasMore: false,
          isLoadingMore: false,
        ),
      ],
      verify: (_) {
        verify(() => staffRepository.getUsers(1)).called(1);
        verify(() => staffRepository.getUsers(2)).called(1);
      },
    );
  });
}
