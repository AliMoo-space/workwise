import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_history_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_history_repo.dart';

class GetAttendanceHistory {
  const GetAttendanceHistory(this._repo);

  final AttendanceHistoryRepo _repo;

  Future<Either<Failure, AttendanceHistoryPageEntity>> call({
    int? month,
    int? year,
    int? perPage,
  }) {
    return _repo.getHistory(month: month, year: year, perPage: perPage);
  }
}
