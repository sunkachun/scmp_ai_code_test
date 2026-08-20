import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/local/token_local_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/staff_repository.dart';
import 'staff_event.dart';
import 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc(this._staffRepository, this._tokenLocalDataSource)
      : super(const StaffInitial()) {
    on<FetchStaffList>(_onFetchStaffList);
    on<FetchNextPage>(_onFetchNextPage);
  }

  final StaffRepository _staffRepository;
  final TokenLocalDataSource _tokenLocalDataSource;

  List<User> _users = [];
  int _currentPage = 0;
  String _token = '';
  bool _isFetchingNext = false;

  Future<void> _onFetchStaffList(
    FetchStaffList event,
    Emitter<StaffState> emit,
  ) async {
    try {
      emit(const StaffLoading());
      _token = await _tokenLocalDataSource.getToken() ?? '';
      final userPage = await _staffRepository.getUsers(1);
      _users = userPage.users;
      _currentPage = userPage.currentPage;
      emit(StaffLoaded(
        users: _users,
        token: _token,
        hasMore: userPage.hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(StaffFailure(e.toString()));
    }
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<StaffState> emit,
  ) async {
    final current = state;
    if (_isFetchingNext || current is! StaffLoaded || !current.hasMore) {
      return;
    }
    _isFetchingNext = true;
    try {
      emit(current.copyWith(isLoadingMore: true));
      final userPage = await _staffRepository.getUsers(_currentPage + 1);
      _users = [..._users, ...userPage.users];
      _currentPage = userPage.currentPage;
      emit(StaffLoaded(
        users: _users,
        token: _token,
        hasMore: userPage.hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(StaffFailure(e.toString()));
    } finally {
      _isFetchingNext = false;
    }
  }
}
