import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';

class AttendanceRepoImpl implements AttendanceRepo {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepoImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, AttendanceEntity>> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final attendance = await remoteDataSource.getTodayAttendance(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(attendance);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final attendance = await remoteDataSource.checkIn(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(attendance);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    try {
      final attendance = await remoteDataSource.checkOut(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(attendance);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
