part of 'attendance_history_cubit.dart';

sealed class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();

  @override
  List<Object?> get props => [];
}

final class AttendanceHistoryInitial extends AttendanceHistoryState {
  const AttendanceHistoryInitial();
}

final class AttendanceHistoryLoading extends AttendanceHistoryState {
  const AttendanceHistoryLoading();
}

final class AttendanceHistorySuccess extends AttendanceHistoryState {
  const AttendanceHistorySuccess(this.history);

  final AttendanceHistoryPageEntity history;

  @override
  List<Object?> get props => [history];
}

final class AttendanceHistoryFailure extends AttendanceHistoryState {
  const AttendanceHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
