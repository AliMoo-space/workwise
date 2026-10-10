import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/usecases/check_in.dart';
import 'package:workwise/features/attendance/domain/usecases/check_out.dart';
import 'package:workwise/features/attendance/domain/usecases/get_today_attendance.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required this.getTodayAttendance,
    CheckIn? checkIn,
    CheckOut? checkOut,
    CheckIn? checkInUseCase,
    CheckOut? checkOutUseCase,
    this.locationProvider,
  }) : _checkIn = checkIn ?? checkInUseCase!,
       _checkOut = checkOut ?? checkOutUseCase!,
       super(const AttendanceInitial());

  final GetTodayAttendance getTodayAttendance;
  final CheckIn _checkIn;
  final CheckOut _checkOut;
  final Future<Position?> Function()? locationProvider;
  Future<void>? _loadFuture;
  bool _hasLoadedAttendance = false;

  Future<void> loadCurrentAttendance() async {
    if (_hasLoadedAttendance && state is AttendanceSuccess) return;
    final position =
        await (locationProvider ?? LocationHelper.getCurrentPosition)();
    if (position == null) {
      emit(
        const AttendanceFailure('Unable to determine your current location.'),
      );
      return;
    }
    await loadAttendance(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<void> loadAttendance({
    required double latitude,
    required double longitude,
  }) async {
    if (_hasLoadedAttendance && state is AttendanceSuccess) return;
    if (_loadFuture != null) return _loadFuture!;

    final future = _loadAttendance(latitude: latitude, longitude: longitude);
    _loadFuture = future;
    try {
      await future;
    } finally {
      _loadFuture = null;
    }
  }

  Future<void> _loadAttendance({
    required double latitude,
    required double longitude,
  }) async {
    emit(const AttendanceLoading());

    final result = await getTodayAttendance(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        emit(AttendanceFailure(failure.message));
      },
      (attendance) {
        _hasLoadedAttendance = true;
        emit(AttendanceSuccess(attendance));
      },
    );
  }

  Future<void> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    if (state is AttendanceActionLoading) return;
    final attendance = _attendanceFromState;
    if (attendance != null) {
      emit(AttendanceActionLoading(attendance));
    } else {
      emit(const AttendanceLoading());
    }
    final result = await _checkIn(latitude: latitude, longitude: longitude);

    result.fold(
      (failure) {
        if (attendance == null) {
          emit(AttendanceFailure(failure.message));
        } else {
          emit(
            AttendanceActionFailure(
              message: failure.message,
              attendance: attendance,
            ),
          );
        }
      },
      (action) {
        _hasLoadedAttendance = false;
        emit(
          AttendanceActionSuccess(
            message: 'Checked in successfully.',
            action: action,
            attendance: attendance,
          ),
        );
      },
    );
  }

  Future<void> checkInCurrentLocation() async {
    final position =
        await (locationProvider ?? LocationHelper.getCurrentPosition)();
    if (position == null) {
      emit(
        const AttendanceFailure('Unable to determine your current location.'),
      );
      return;
    }
    await checkIn(latitude: position.latitude, longitude: position.longitude);
  }

  Future<void> checkOut({double? latitude, double? longitude}) async {
    if (state is AttendanceActionLoading) return;
    final attendance = _attendanceFromState;
    if (attendance != null) {
      emit(AttendanceActionLoading(attendance));
    } else {
      emit(const AttendanceLoading());
    }
    final result = await _checkOut(latitude: latitude, longitude: longitude);

    result.fold(
      (failure) {
        if (attendance == null) {
          emit(AttendanceFailure(failure.message));
        } else {
          emit(
            AttendanceActionFailure(
              message: failure.message,
              attendance: attendance,
            ),
          );
        }
      },
      (action) {
        _hasLoadedAttendance = false;
        emit(
          AttendanceActionSuccess(
            message: 'Checked out successfully.',
            action: action,
            attendance: attendance,
          ),
        );
      },
    );
  }

  Future<void> performCheckIn({
    required double latitude,
    required double longitude,
  }) => checkIn(latitude: latitude, longitude: longitude);

  Future<void> performCheckOut({
    required double latitude,
    required double longitude,
  }) => checkOut(latitude: latitude, longitude: longitude);

  AttendanceEntity? get _attendanceFromState {
    final currentState = state;
    if (currentState is AttendanceSuccess) return currentState.attendance;
    if (currentState is AttendanceActionLoading) {
      return currentState.attendance;
    }
    if (currentState is AttendanceActionFailure) {
      return currentState.attendance;
    }
    if (currentState is AttendanceActionSuccess) {
      return currentState.attendance;
    }
    return null;
  }
}
