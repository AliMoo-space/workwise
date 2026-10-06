import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  })  : _checkIn = checkIn ?? checkInUseCase!,
        _checkOut = checkOut ?? checkOutUseCase!,
        super(const AttendanceInitial());

  final GetTodayAttendance getTodayAttendance;
  final CheckIn _checkIn;
  final CheckOut _checkOut;

  Future<void> loadAttendance({
    required double latitude,
    required double longitude,
  }) async {
    emit(AttendanceLoading());

    final result = await getTodayAttendance(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        emit(AttendanceFailure(failure.message));
      },
      (attendance) {
        emit(AttendanceSuccess(attendance));
      },
    );
  }

  Future<void> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    emit(AttendanceLoading());

    final result = await _checkIn(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        emit(AttendanceFailure(failure.message));
      },
      (action) {
        emit(
          AttendanceActionSuccess(
            message: 'Checked in successfully.',
            action: action,
          ),
        );
      },
    );
  }

  Future<void> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    emit(AttendanceLoading());

    final result = await _checkOut(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        emit(AttendanceFailure(failure.message));
      },
      (action) {
        emit(
          AttendanceActionSuccess(
            message: 'Checked out successfully.',
            action: action,
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
}