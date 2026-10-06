import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/failure.dart';
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

  @override
  Future<Either<Failure, AttendanceEntity>> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    return todayResult!;
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkIn({
    required double latitude,
    required double longitude,
  }) async {
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

  setUp(() {
    fakeRepo = FakeAttendanceRepo();
    getTodayAttendance = GetTodayAttendance(attendanceRepo: fakeRepo);
    checkInUseCase = CheckIn(fakeRepo);
    checkOutUseCase = CheckOut(fakeRepo);
    cubit = AttendanceCubit(
      getTodayAttendance: getTodayAttendance,
      checkInUseCase: checkInUseCase,
      checkOutUseCase: checkOutUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AttendanceInitial', () {
    expect(cubit.state, const AttendanceInitial());
  });

  group('loadAttendance', () {
    test('emits [AttendanceLoading, AttendanceSuccess] on successful load', () async {
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

      final expected = [
        const AttendanceLoading(),
        AttendanceSuccess(entity),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);
    });

    test('emits [AttendanceLoading, AttendanceFailure] when repository fails', () async {
      fakeRepo.todayResult = const Left(ServerFailure('Server Error'));

      final expected = [
        const AttendanceLoading(),
        const AttendanceFailure('Server Error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.loadAttendance(latitude: 30.0444, longitude: 31.2357);
    });
  });

  group('checkIn', () {
    test('emits [AttendanceLoading, AttendanceActionSuccess] on success', () async {
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
    });

    test('emits [AttendanceLoading, AttendanceFailure] on error', () async {
      fakeRepo.checkInResult = const Left(ValidationFailure('Outside radius'));

      final expected = [
        const AttendanceLoading(),
        const AttendanceFailure('Outside radius'),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.checkIn(latitude: 30.0444, longitude: 31.2357);
    });
  });

  group('checkOut', () {
    test('emits [AttendanceLoading, AttendanceActionSuccess] on success', () async {
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
    });

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
