import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';

class CheckOut {
  final AttendanceRepo repo;

  CheckOut(this.repo);
  Future<Either<Failure, AttendanceActionEntity>> call({
    double? latitude,
    double? longitude,
  }) async {
    return await repo.checkOut(
      latitude: latitude,
      longitude: longitude,
    );
  }
}