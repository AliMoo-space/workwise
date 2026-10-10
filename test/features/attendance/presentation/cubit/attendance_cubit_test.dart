import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';
import 'package:workwise/features/attendance/domain/usecases/check_in.dart';
import 'package:workwise/features/attendance/domain/usecases/check_out.dart';
import 'package:workwise/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';

class FakeAttendanceRepo implements AttendanceRepo {
  Either<Failure, AttendanceEntity>? todayResult;
  Either<Failure, AttendanceActionEntity>? checkInResult;
  Either<Failure, AttendanceActionEntity>? checkOutResult;
  int todayCalls = 0;
  int checkInCalls = 0;

  @override
  Future<Either<Failure, AttendanceEntity>> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    todayCalls++;
    return todayResult!;
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    checkInCalls++;
    return checkInResult!;
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    return checkOutResult!;
  }
}

void main() {
  late FakeAttendanceRepo fakeRepo;
  late GetTodayAttendance getTodayAttendance;
  late CheckIn checkInUseCase;
  late CheckOut checkOutUseCase;
  late AttendanceCubit cubit;
  late LocationAcquireResult mockAcquireResult;
  late LocationStatusSnapshot mockStatusSnapshot;
  bool? lastAllowLastKnownFallback;
  bool? lastIsUserInitiated;

  setUp(() {
    fakeRepo = FakeAttendanceRepo();
    getTodayAttendance = GetTodayAttendance(attendanceRepo: fakeRepo);
    checkInUseCase = CheckIn(fakeRepo);
    checkOutUseCase = CheckOut(fakeRepo);
    mockAcquireResult = LocationAcquireSuccess(
      coordinates: LocationCoordinates(
        latitude: 30.0444,
        longitude: 31.2357,
        accuracyMeters: 10.0,
        timestamp: DateTime(2026, 10, 10, 9),
      ),
    );
    mockStatusSnapshot = const LocationStatusSnapshot(
      permissionState: LocationPermissionState.granted,
    );
    lastAllowLastKnownFallback = null;
    lastIsUserInitiated = null;

    cubit = AttendanceCubit(
      getTodayAttendance: getTodayAttendance,
      checkInUseCase: checkInUseCase,
      checkOutUseCase: checkOutUseCase,
      locationAcquirer:
          ({
            bool isUserInitiated = false,
            bool allowLastKnownFallback = true,
          }) async {
            lastAllowLastKnownFallback = allowLastKnownFallback;
            lastIsUserInitiated = isUserInitiated;
            return mockAcquireResult;
          },
      locationStatusChecker: () async {
        return mockStatusSnapshot;
      },
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AttendanceInitial', () {
    expect(cubit.state, const AttendanceInitial());
  });

  group('loadAttendance', () {
    test(
      'emits [AttendanceLoading, AttendanceSuccess] on successful load',
      () async {
        final entity = AttendanceEntity(
          status: 'On Shift',
          checkInTime: '09:00 AM',
          checkOutTime: null,
          workedTime: '01:00:00',
          distanceMeters: 10.0,
          isInsideRadius: true,
          canCheckIn: false,
          canCheckOut: true,
        );
        fakeRepo.todayResult = Right(entity);

        final expected = [const AttendanceLoading(), AttendanceSuccess(entity)];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);
      },
    );

    test(
      'emits [AttendanceLoading, AttendanceFailure] when repository fails',
      () async {
        fakeRepo.todayResult = const Left(ServerFailure('Server Error'));

        final expected = [
          const AttendanceLoading(),
          const AttendanceFailure('Server Error'),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);
      },
    );
  });

  group('loadCurrentAttendance', () {
    test('acquires location and loads attendance on success', () async {
      final entity = AttendanceEntity(
        status: 'On Shift',
        checkInTime: '09:00 AM',
        checkOutTime: null,
        workedTime: '01:00:00',
        distanceMeters: 15.0,
        isInsideRadius: true,
        canCheckIn: false,
        canCheckOut: true,
      );
      fakeRepo.todayResult = Right(entity);

      await cubit.loadCurrentAttendance(isUserInitiated: true);

      expect(cubit.state, AttendanceSuccess(entity));
      expect(lastAllowLastKnownFallback, isTrue);
      expect(lastIsUserInitiated, isTrue);
    });

    test(
      'emits specific AttendanceFailure with errorType when GPS is disabled',
      () async {
        mockAcquireResult = LocationAcquireFailure(
          permissionState: LocationPermissionState.serviceDisabled,
          errorType: LocationErrorType.serviceDisabled,
        );

        await cubit.loadCurrentAttendance();

        expect(
          cubit.state,
          AttendanceFailure(
            LocationErrorType.serviceDisabled.defaultMessage,
            locationErrorType: LocationErrorType.serviceDisabled,
            permissionState: LocationPermissionState.serviceDisabled,
          ),
        );
        expect(
          (cubit.state as AttendanceFailure).canOpenLocationSettings,
          isTrue,
        );
        expect(fakeRepo.todayCalls, 0);
      },
    );

    test(
      'emits specific AttendanceFailure when permission is permanently denied',
      () async {
        mockAcquireResult = LocationAcquireFailure(
          permissionState: LocationPermissionState.permanentlyDenied,
          errorType: LocationErrorType.permissionPermanentlyDenied,
        );

        await cubit.loadCurrentAttendance();

        expect(
          cubit.state,
          AttendanceFailure(
            LocationErrorType.permissionPermanentlyDenied.defaultMessage,
            locationErrorType: LocationErrorType.permissionPermanentlyDenied,
            permissionState: LocationPermissionState.permanentlyDenied,
          ),
        );
        expect((cubit.state as AttendanceFailure).canOpenAppSettings, isTrue);
        expect(fakeRepo.todayCalls, 0);
      },
    );
  });

  group('checkIn & checkInCurrentLocation', () {
    test('preserves attendance when the action fails', () async {
      final attendance = AttendanceEntity(
        status: 'Off Shift',
        checkInTime: null,
        checkOutTime: null,
        workedTime: '0h 0m 0s',
        distanceMeters: 10,
        isInsideRadius: true,
        canCheckIn: true,
        canCheckOut: false,
      );
      fakeRepo.todayResult = Right(attendance);
      fakeRepo.checkInResult = const Left(ValidationFailure('Outside radius'));

      await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);
      await cubit.checkIn(latitude: 30.0444, longitude: 31.2357);

      expect(
        cubit.state,
        AttendanceActionFailure(
          message: 'Outside radius',
          attendance: attendance,
        ),
      );
    });

    test(
      'emits [AttendanceLoading, AttendanceActionSuccess] on success',
      () async {
        final actionEntity = AttendanceActionEntity(
          id: 1,
          userId: 1,
          date: '2026-10-05',
          checkIn: '09:00 AM',
          checkOut: null,
          status: 'Present',
          workedTime: null,
          isException: false,
        );
        fakeRepo.checkInResult = Right(actionEntity);

        final expected = [
          const AttendanceLoading(),
          AttendanceActionSuccess(
            message: 'Checked in successfully.',
            action: actionEntity,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkIn(latitude: 30.0444, longitude: 31.2357);
      },
    );

    test('emits [AttendanceLoading, AttendanceFailure] on error', () async {
      fakeRepo.checkInResult = const Left(ValidationFailure('Outside radius'));

      final expected = [
        const AttendanceLoading(),
        const AttendanceFailure('Outside radius'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.checkIn(latitude: 30.0444, longitude: 31.2357);
    });

    test(
      'checkInCurrentLocation blocks check-in and preserves attendance when location fails',
      () async {
        final attendance = AttendanceEntity(
          status: 'Off Shift',
          checkInTime: null,
          checkOutTime: null,
          workedTime: '0h 0m 0s',
          distanceMeters: 10,
          isInsideRadius: true,
          canCheckIn: true,
          canCheckOut: false,
        );
        fakeRepo.todayResult = Right(attendance);
        await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);

        mockAcquireResult = LocationAcquireFailure(
          permissionState: LocationPermissionState.approximateGranted,
          errorType: LocationErrorType.preciseLocationRequired,
        );

        await cubit.checkInCurrentLocation(isUserInitiated: true);

        expect(lastAllowLastKnownFallback, isFalse);
        expect(fakeRepo.checkInCalls, 0);
        expect(
          cubit.state,
          AttendanceActionFailure(
            message: LocationErrorType.preciseLocationRequired.defaultMessage,
            attendance: attendance,
            locationErrorType: LocationErrorType.preciseLocationRequired,
            permissionState: LocationPermissionState.approximateGranted,
          ),
        );
      },
    );
  });

  group('onAppResumed', () {
    test(
      'automatically reloads attendance when returning from Settings after fixing permission',
      () async {
        mockAcquireResult = LocationAcquireFailure(
          permissionState: LocationPermissionState.permanentlyDenied,
          errorType: LocationErrorType.permissionPermanentlyDenied,
        );
        await cubit.loadCurrentAttendance();
        expect(cubit.state, isA<AttendanceFailure>());

        // User enables permission in Settings and returns to the app.
        final entity = AttendanceEntity(
          status: 'Off Shift',
          checkInTime: null,
          checkOutTime: null,
          workedTime: '00:00:00',
          distanceMeters: 10.0,
          isInsideRadius: true,
          canCheckIn: true,
          canCheckOut: false,
        );
        fakeRepo.todayResult = Right(entity);
        mockStatusSnapshot = const LocationStatusSnapshot(
          permissionState: LocationPermissionState.granted,
        );
        mockAcquireResult = LocationAcquireSuccess(
          coordinates: LocationCoordinates(
            latitude: 30.0444,
            longitude: 31.2357,
            accuracyMeters: 8.0,
            timestamp: DateTime(2026, 10, 10, 9),
          ),
        );

        await cubit.onAppResumed();

        expect(cubit.state, AttendanceSuccess(entity));
      },
    );

    test(
      'transitions to AttendanceFailure if permission is revoked while app is in background',
      () async {
        final entity = AttendanceEntity(
          status: 'On Shift',
          checkInTime: '09:00 AM',
          checkOutTime: null,
          workedTime: '01:00:00',
          distanceMeters: 10.0,
          isInsideRadius: true,
          canCheckIn: false,
          canCheckOut: true,
        );
        fakeRepo.todayResult = Right(entity);
        await cubit.loadCurrentAttendance();
        expect(cubit.state, AttendanceSuccess(entity));

        // User revokes permission in Settings and resumes the app.
        mockStatusSnapshot = const LocationStatusSnapshot(
          permissionState: LocationPermissionState.revoked,
          errorType: LocationErrorType.permissionDenied,
        );

        await cubit.onAppResumed();

        expect(
          cubit.state,
          AttendanceFailure(
            LocationErrorType.permissionDenied.defaultMessage,
            locationErrorType: LocationErrorType.permissionDenied,
            permissionState: LocationPermissionState.revoked,
          ),
        );
      },
    );
  });

  group('checkOut', () {
    test(
      'emits [AttendanceLoading, AttendanceActionSuccess] on success',
      () async {
        final actionEntity = AttendanceActionEntity(
          id: 1,
          userId: 1,
          date: '2026-10-05',
          checkIn: '09:00 AM',
          checkOut: '05:00 PM',
          status: 'Present',
          workedTime: '08:00:00',
          isException: false,
        );
        fakeRepo.checkOutResult = Right(actionEntity);

        final expected = [
          const AttendanceLoading(),
          AttendanceActionSuccess(
            message: 'Checked out successfully.',
            action: actionEntity,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expected));

        await cubit.checkOut();
      },
    );

    test('emits [AttendanceLoading, AttendanceFailure] on error', () async {
      fakeRepo.checkOutResult = const Left(ServerFailure('Checkout failed'));

      final expected = [
        const AttendanceLoading(),
        const AttendanceFailure('Checkout failed'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.checkOut();
    });
  });
}
