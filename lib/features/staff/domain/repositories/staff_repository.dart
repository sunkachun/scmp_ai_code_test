import '../entities/user_page.dart';

abstract class StaffRepository {
  Future<UserPage> getUsers(int page);
}
