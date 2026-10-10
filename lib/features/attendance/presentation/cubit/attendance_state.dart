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
  const AttendanceFailure(
    this.message, {
    this.locationErrorType,
    this.permissionState,
  });

  final String message;
  final LocationErrorType? locationErrorType;
  final LocationPermissionState? permissionState;

  bool get isLocationError => locationErrorType != null;

  bool get canOpenAppSettings => locationErrorType?.canOpenAppSettings ?? false;

  bool get canOpenLocationSettings =>
      locationErrorType?.canOpenLocationSettings ?? false;

  String localizedMessage(AppLocalizations l10n) =>
      locationErrorType?.localizedMessage(l10n) ?? message;

  @override
  List<Object> get props => [message, ?locationErrorType, ?permissionState];
}

final class AttendanceActionFailure extends AttendanceState {
  const AttendanceActionFailure({
    required this.message,
    required this.attendance,
    this.locationErrorType,
    this.permissionState,
  });

  final String message;
  final AttendanceEntity attendance;
  final LocationErrorType? locationErrorType;
  final LocationPermissionState? permissionState;

  bool get isLocationError => locationErrorType != null;

  bool get canOpenAppSettings => locationErrorType?.canOpenAppSettings ?? false;

  bool get canOpenLocationSettings =>
      locationErrorType?.canOpenLocationSettings ?? false;

  String localizedMessage(AppLocalizations l10n) =>
      locationErrorType?.localizedMessage(l10n) ?? message;

  @override
  List<Object> get props => [
    message,
    attendance,
    ?locationErrorType,
    ?permissionState,
  ];
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
