import '../../domain/entities/user_page.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_datasource.dart';

class StaffRepositoryImpl implements StaffRepository {
  StaffRepositoryImpl(this._remoteDataSource);

  final StaffRemoteDataSource _remoteDataSource;

  @override
  Future<UserPage> getUsers(int page) {
    return _remoteDataSource.getUsers(page);
  }
}
