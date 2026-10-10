part of 'attendance_cubit.dart';

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

final class AttendanceActionLoading extends AttendanceState {
  const AttendanceActionLoading(this.attendance);

  final AttendanceEntity attendance;

  @override
  List<Object> get props => [attendance];
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

final class AttendanceActionFailure extends AttendanceState {
  const AttendanceActionFailure({
    required this.message,
    required this.attendance,
  });

  final String message;
  final AttendanceEntity attendance;

  @override
  List<Object> get props => [message, attendance];
}

final class AttendanceActionSuccess extends AttendanceState {
  const AttendanceActionSuccess({
    required this.message,
    this.action,
    this.attendance,
  });

  final String message;
  final AttendanceActionEntity? action;
  final AttendanceEntity? attendance;

  @override
  List<Object> get props => [message, ?action, ?attendance];
}
