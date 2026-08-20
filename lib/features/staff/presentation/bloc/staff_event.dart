import 'package:equatable/equatable.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object?> get props => [];
}

class FetchStaffList extends StaffEvent {
  const FetchStaffList();
}

class FetchNextPage extends StaffEvent {
  const FetchNextPage();
}
