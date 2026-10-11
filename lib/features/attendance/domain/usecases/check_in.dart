import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';

class CheckIn {
  final AttendanceRepo repo;  
  CheckIn(this.repo);
  Future<Either<Failure, AttendanceActionEntity>> call({
    required double latitude,
    required double longitude,
  }) async {
    return await repo.checkIn(
      latitude: latitude,
      longitude: longitude,
    );
  }
}