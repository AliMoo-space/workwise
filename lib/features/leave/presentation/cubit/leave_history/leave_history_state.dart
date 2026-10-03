import 'package:equatable/equatable.dart';
import 'package:workwise/features/leave/domain/entity/leave_history_entity.dart';

abstract class LeaveHistoryState extends Equatable {
  const LeaveHistoryState();

  @override
  List<Object?> get props => [];
}

class LeaveHistoryInitial extends LeaveHistoryState {
  const LeaveHistoryInitial();
}

class LeaveHistoryLoading extends LeaveHistoryState {
  const LeaveHistoryLoading();
}

class LeaveHistorySuccess extends LeaveHistoryState {
  final List<LeaveHistoryEntity> leaveHistory;

  const LeaveHistorySuccess(this.leaveHistory);

  @override
  List<Object?> get props => [leaveHistory];
}

class LeaveHistoryFailure extends LeaveHistoryState {
  final String message;

  const LeaveHistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
