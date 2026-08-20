import '../../domain/entities/user_page.dart';

abstract class StaffRemoteDataSource {
  Future<UserPage> getUsers(int page);
}
