part of 'attendance_cubit.dart';

// AttendanceActionEntity is imported by the library containing this part.
sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

final class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

final class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

final class AttendanceSuccess extends AttendanceState {
  const AttendanceSuccess(this.attendance);

  final AttendanceEntity attendance;

  @override
  List<Object> get props => [attendance];
}

final class AttendanceFailure extends AttendanceState {
  const AttendanceFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class AttendanceActionSuccess extends AttendanceState {
  const AttendanceActionSuccess({
    required this.message,
    this.action,
  });

  final String message;
  final AttendanceActionEntity? action;

  @override
  List<Object> get props => [message, ?action];
}
