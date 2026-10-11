import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/usecases/check_in.dart';
import 'package:workwise/features/attendance/domain/usecases/check_out.dart';
import 'package:workwise/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:workwise/generated/app_localizations.dart';

part 'attendance_state.dart';

typedef LocationAcquireCallback =
    Future<LocationAcquireResult> Function({
      bool isUserInitiated,
      bool allowLastKnownFallback,
    });

typedef LocationStatusCallback = Future<LocationStatusSnapshot> Function();

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required this.getTodayAttendance,
    CheckIn? checkIn,
    CheckOut? checkOut,
    CheckIn? checkInUseCase,
    CheckOut? checkOutUseCase,
    this.locationProvider,
    this.locationAcquirer,
    this.locationStatusChecker,
  }) : _checkIn = checkIn ?? checkInUseCase!,
       _checkOut = checkOut ?? checkOutUseCase!,
       super(const AttendanceInitial());

  final GetTodayAttendance getTodayAttendance;
  final CheckIn _checkIn;
  final CheckOut _checkOut;
  final Future<Position?> Function()? locationProvider;
  final LocationAcquireCallback? locationAcquirer;
  final LocationStatusCallback? locationStatusChecker;

  Future<void>? _loadFuture;
  bool _hasLoadedAttendance = false;
  LocationCoordinates? _lastKnownCoordinates;

  LocationCoordinates? get lastKnownCoordinates => _lastKnownCoordinates;

  Future<void> loadCurrentAttendance({
    bool isUserInitiated = false,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _hasLoadedAttendance && state is AttendanceSuccess) {
      return;
    }
    if (_loadFuture != null) return _loadFuture!;

    final future = _loadCurrentAttendanceInternal(
      isUserInitiated: isUserInitiated,
    );
    _loadFuture = future;
    try {
      await future;
    } finally {
      if (identical(_loadFuture, future)) {
        _loadFuture = null;
      }
    }
  }

  Future<void> _loadCurrentAttendanceInternal({
    required bool isUserInitiated,
  }) async {
    if (state is! AttendanceLoading) {
      emit(const AttendanceLoading());
    }

    final locationResult = await _acquireLocation(
      isUserInitiated: isUserInitiated,
      allowLastKnownFallback: true,
    );
    if (isClosed) return;

    switch (locationResult) {
      case LocationAcquireFailure(
        :final message,
        :final errorType,
        :final permissionState,
      ):
        _hasLoadedAttendance = false;
        emit(
          AttendanceFailure(
            message,
            locationErrorType: errorType,
            permissionState: permissionState,
          ),
        );
      case LocationAcquireSuccess(:final coordinates):
        _lastKnownCoordinates = coordinates;
        await _loadAttendance(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        );
    }
  }

  Future<void> loadAttendance({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _hasLoadedAttendance && state is AttendanceSuccess) {
      return;
    }
    if (_loadFuture != null) return _loadFuture!;

    if (!LocationHelper.isValidCoordinate(latitude, longitude)) {
      _hasLoadedAttendance = false;
      emit(
        AttendanceFailure(
          LocationErrorType.temporarilyUnavailable.defaultMessage,
          locationErrorType: LocationErrorType.temporarilyUnavailable,
          permissionState: LocationPermissionState.granted,
        ),
      );
      return;
    }

    final future = _loadAttendance(latitude: latitude, longitude: longitude);
    _loadFuture = future;
    try {
      await future;
    } finally {
      if (identical(_loadFuture, future)) {
        _loadFuture = null;
      }
    }
  }

  Future<void> _loadAttendance({
    required double latitude,
    required double longitude,
  }) async {
    if (state is! AttendanceLoading) {
      emit(const AttendanceLoading());
    }

    final result = await getTodayAttendance(
      latitude: latitude,
      longitude: longitude,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        _hasLoadedAttendance = false;
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

    if (!LocationHelper.isValidCoordinate(latitude, longitude)) {
      final errorMessage =
          LocationErrorType.temporarilyUnavailable.defaultMessage;
      if (attendance == null) {
        emit(
          AttendanceFailure(
            errorMessage,
            locationErrorType: LocationErrorType.temporarilyUnavailable,
            permissionState: LocationPermissionState.granted,
          ),
        );
      } else {
        emit(
          AttendanceActionFailure(
            message: errorMessage,
            attendance: attendance,
            locationErrorType: LocationErrorType.temporarilyUnavailable,
            permissionState: LocationPermissionState.granted,
          ),
        );
      }
      return;
    }

    if (attendance != null) {
      emit(AttendanceActionLoading(attendance));
    } else {
      emit(const AttendanceLoading());
    }

    await _executeCheckIn(
      latitude: latitude,
      longitude: longitude,
      attendance: attendance,
    );
  }

  Future<void> checkInCurrentLocation({bool isUserInitiated = true}) async {
    if (state is AttendanceActionLoading || state is AttendanceLoading) return;
    final attendance = _attendanceFromState;
    if (attendance != null) {
      emit(AttendanceActionLoading(attendance));
    } else {
      emit(const AttendanceLoading());
    }

    // Never silently use stale or inaccurate last-known coordinates for check-in.
    final locationResult = await _acquireLocation(
      isUserInitiated: isUserInitiated,
      allowLastKnownFallback: false,
    );
    if (isClosed) return;

    switch (locationResult) {
      case LocationAcquireFailure(
        :final message,
        :final errorType,
        :final permissionState,
      ):
        if (attendance == null) {
          emit(
            AttendanceFailure(
              message,
              locationErrorType: errorType,
              permissionState: permissionState,
            ),
          );
        } else {
          emit(
            AttendanceActionFailure(
              message: message,
              attendance: attendance,
              locationErrorType: errorType,
              permissionState: permissionState,
            ),
          );
        }
      case LocationAcquireSuccess(:final coordinates):
        _lastKnownCoordinates = coordinates;
        await _executeCheckIn(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          attendance: attendance,
        );
    }
  }

  Future<void> _executeCheckIn({
    required double latitude,
    required double longitude,
    required AttendanceEntity? attendance,
  }) async {
    final result = await _checkIn(latitude: latitude, longitude: longitude);
    if (isClosed) return;

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

  Future<void> checkOut({double? latitude, double? longitude}) async {
    if (state is AttendanceActionLoading) return;
    final attendance = _attendanceFromState;
    if (attendance != null) {
      emit(AttendanceActionLoading(attendance));
    } else {
      emit(const AttendanceLoading());
    }
    final result = await _checkOut(latitude: latitude, longitude: longitude);
    if (isClosed) return;

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

  /// Revalidates location service and permission state when the app resumes
  /// from background or after returning from system Settings.
  Future<void> onAppResumed() async {
    if (_loadFuture != null ||
        state is AttendanceLoading ||
        state is AttendanceActionLoading) {
      return;
    }

    final status =
        await (locationStatusChecker ?? LocationHelper.checkLocationStatus)();
    if (isClosed) return;

    final currentState = state;
    final isCurrentlyLocationError =
        (currentState is AttendanceFailure && currentState.isLocationError) ||
        (currentState is AttendanceActionFailure &&
            currentState.isLocationError);

    if (isCurrentlyLocationError) {
      if (status.isReady) {
        await loadCurrentAttendance(isUserInitiated: false, forceRefresh: true);
      } else if (status.errorType != null) {
        final errorType = status.errorType!;
        final attendance = _attendanceFromState;
        if (attendance != null && currentState is AttendanceActionFailure) {
          emit(
            AttendanceActionFailure(
              message: errorType.defaultMessage,
              attendance: attendance,
              locationErrorType: errorType,
              permissionState: status.permissionState,
            ),
          );
        } else {
          emit(
            AttendanceFailure(
              errorType.defaultMessage,
              locationErrorType: errorType,
              permissionState: status.permissionState,
            ),
          );
        }
      }
      return;
    }

    // If attendance was loaded, verify permission/GPS was not revoked while in Settings.
    if (_attendanceFromState != null &&
        !status.isReady &&
        status.errorType != null) {
      _hasLoadedAttendance = false;
      final errorType = status.errorType!;
      emit(
        AttendanceFailure(
          errorType.defaultMessage,
          locationErrorType: errorType,
          permissionState: status.permissionState,
        ),
      );
    }
  }

  Future<LocationAcquireResult> _acquireLocation({
    required bool isUserInitiated,
    required bool allowLastKnownFallback,
  }) async {
    if (locationAcquirer != null) {
      return locationAcquirer!(
        isUserInitiated: isUserInitiated,
        allowLastKnownFallback: allowLastKnownFallback,
      );
    }

    if (locationProvider != null) {
      try {
        final position = await locationProvider!();
        if (position == null) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.unableToDetermine,
            permissionState: LocationPermissionState.unableToDetermine,
            diagnosticMessage: 'Custom locationProvider returned null.',
          );
        }
        if (!LocationHelper.isValidCoordinate(
          position.latitude,
          position.longitude,
        )) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.temporarilyUnavailable,
            permissionState: LocationPermissionState.granted,
            diagnosticMessage:
                'Custom locationProvider returned invalid coordinates.',
          );
        }
        final hasAccuracy = position.hasAccuracy || position.accuracy > 0;
        if (hasAccuracy &&
            position.accuracy >
                LocationHelper.defaultMaxAcceptableAccuracyMeters) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.preciseLocationRequired,
            permissionState: LocationPermissionState.approximateGranted,
            diagnosticMessage:
                'Custom locationProvider returned inaccurate position.',
          );
        }
        return LocationAcquireSuccess(
          coordinates: LocationCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            accuracyMeters: hasAccuracy ? position.accuracy : null,
            timestamp: position.timestamp,
          ),
          position: position,
        );
      } catch (e) {
        return LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.error,
          diagnosticMessage: 'Custom locationProvider threw ${e.runtimeType}.',
          cause: e,
        );
      }
    }

    return LocationHelper.acquireCurrentLocation(
      isUserInitiated: isUserInitiated,
      allowLastKnownFallback: allowLastKnownFallback,
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
