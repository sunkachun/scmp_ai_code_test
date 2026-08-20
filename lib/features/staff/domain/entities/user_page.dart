import 'package:equatable/equatable.dart';

import 'user.dart';

class UserPage extends Equatable {
  const UserPage({
    required this.users,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  final List<User> users;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  @override
  List<Object?> get props => [users, currentPage, totalPages, hasMore];
}
