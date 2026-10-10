import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/data/datasource/attendance_history_remote_data_source.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_history_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_history_repo.dart';

class AttendanceHistoryRepoImpl implements AttendanceHistoryRepo {
  const AttendanceHistoryRepoImpl({required this.remoteDataSource});

  final AttendanceHistoryRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AttendanceHistoryPageEntity>> getHistory({
    int? month,
    int? year,
    int? perPage,
  }) async {
    try {
      return Right(
        await remoteDataSource.getHistory(
          month: month,
          year: year,
          perPage: perPage,
        ),
      );
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
