part of 'leave_history_cubit.dart';

sealed class LeaveHistoryState extends Equatable {
  const LeaveHistoryState();

  @override
  List<Object?> get props => [];
}

final class LeaveHistoryInitial extends LeaveHistoryState {
  const LeaveHistoryInitial();
}

final class LeaveHistoryLoading extends LeaveHistoryState {
  const LeaveHistoryLoading();
}

final class LeaveHistorySuccess extends LeaveHistoryState {
  final List<LeaveHistory> history;

  const LeaveHistorySuccess({required this.history});

  @override
  List<Object?> get props => [history];
}

final class LeaveHistoryFailure extends LeaveHistoryState {
  final String message;

  const LeaveHistoryFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
