import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';

class GetTodayAttendance {
  final AttendanceRepo _attendanceRepo;

  GetTodayAttendance({required this._attendanceRepo});

  Future<Either<Failure, AttendanceEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return _attendanceRepo.getTodayAttendance(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
