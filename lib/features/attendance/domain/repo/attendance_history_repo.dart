import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_history_entity.dart';

abstract interface class AttendanceHistoryRepo {
  Future<Either<Failure, AttendanceHistoryPageEntity>> getHistory({
    int? month,
    int? year,
    int? perPage,
  });
}
