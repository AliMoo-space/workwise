import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:workwise/features/attendance/data/models/attendance_action_model.dart';
import 'package:workwise/features/attendance/data/models/attendance_model.dart';
import 'package:workwise/features/attendance/data/repo/attendance_repo_impl.dart';

class FakeAttendanceRemoteDataSource implements AttendanceRemoteDataSource {
  AttendanceModel? todayAttendanceResult;
  AttendanceActionModel? checkInResult;
  AttendanceActionModel? checkOutResult;
  Exception? exceptionToThrow;

  @override
  Future<AttendanceModel> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return todayAttendanceResult!;
  }

  @override
  Future<AttendanceActionModel> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return checkInResult!;
  }

  @override
  Future<AttendanceActionModel> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return checkOutResult!;
  }
}

void main() {
  late FakeAttendanceRemoteDataSource fakeRemoteDataSource;
  late AttendanceRepoImpl repo;

  setUp(() {
    fakeRemoteDataSource = FakeAttendanceRemoteDataSource();
    repo = AttendanceRepoImpl(remoteDataSource: fakeRemoteDataSource);
  });

  group('AttendanceRepoImpl - getTodayAttendance', () {
    test('returns Right(AttendanceEntity) when remoteDataSource succeeds', () async {
      final model = AttendanceModel(
        status: 'Off Shift',
        checkInTime: null,
        checkOutTime: null,
        workedTime: '0h 0m 0s',
        distanceMeters: 50.0,
        isInsideRadius: true,
        canCheckIn: true,
        canCheckOut: false,
      );
      fakeRemoteDataSource.todayAttendanceResult = model;

      final result = await repo.getTodayAttendance(latitude: 30.0, longitude: 31.0);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be right'),
        (entity) => expect(entity.status, 'Off Shift'),
      );
    });

    test('returns Left(ServerFailure) when ServerException is thrown', () async {
      fakeRemoteDataSource.exceptionToThrow = const ServerException('Server error');

      final result = await repo.getTodayAttendance(latitude: 30.0, longitude: 31.0);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be left'),
      );
    });

    test('returns Left(NetworkFailure) when NetworkException is thrown', () async {
      fakeRemoteDataSource.exceptionToThrow = const NetworkException('No connection');

      final result = await repo.getTodayAttendance(latitude: 30.0, longitude: 31.0);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should be left'),
      );
    });

    test('returns Left(UnauthorizedFailure) when UnauthorizedException is thrown', () async {
      fakeRemoteDataSource.exceptionToThrow = const UnauthorizedException('Unauthorized');

      final result = await repo.getTodayAttendance(latitude: 30.0, longitude: 31.0);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (_) => fail('Should be left'),
      );
    });
  });

  group('AttendanceRepoImpl - checkIn', () {
    test('returns Right(AttendanceActionEntity) on success', () async {
      final actionModel = AttendanceActionModel(
        id: 10,
        userId: 1,
        date: '2026-09-12',
        checkIn: '09:05 AM',
        checkOut: null,
        status: 'Present',
        workedTime: null,
        isException: false,
      );
      fakeRemoteDataSource.checkInResult = actionModel;

      final result = await repo.checkIn(latitude: 30.0, longitude: 31.0);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be right'),
        (entity) => expect(entity.status, 'Present'),
      );
    });

    test('returns Left(ValidationFailure) when ValidationException is thrown', () async {
      fakeRemoteDataSource.exceptionToThrow = const ValidationException('Out of office');

      final result = await repo.checkIn(latitude: 30.0, longitude: 31.0);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should be left'),
      );
    });
  });

  group('AttendanceRepoImpl - checkOut', () {
    test('returns Right(AttendanceActionEntity) on success', () async {
      final actionModel = AttendanceActionModel(
        id: 3,
        userId: 6,
        date: '2026-09-24',
        checkIn: '06:52 PM',
        checkOut: '06:52 PM',
        status: 'Late',
        workedTime: '00:00:05',
        isException: true,
      );
      fakeRemoteDataSource.checkOutResult = actionModel;

      final result = await repo.checkOut(latitude: 30.0, longitude: 31.0);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be right'),
        (entity) => expect(entity.status, 'Late'),
      );
    });
  });
}
