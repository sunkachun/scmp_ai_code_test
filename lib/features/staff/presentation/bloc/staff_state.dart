import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class StaffState extends Equatable {
  const StaffState();

  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {
  const StaffInitial();
}

class StaffLoading extends StaffState {
  const StaffLoading();
}

class StaffLoaded extends StaffState {
  const StaffLoaded({
    required this.users,
    required this.token,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final List<User> users;
  final String token;
  final bool hasMore;
  final bool isLoadingMore;

  StaffLoaded copyWith({
    List<User>? users,
    String? token,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return StaffLoaded(
      users: users ?? this.users,
      token: token ?? this.token,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [users, token, hasMore, isLoadingMore];
}

class StaffFailure extends StaffState {
  const StaffFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
