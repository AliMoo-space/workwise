import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

abstract interface class AttendanceRepo {
  Future<Either<Failure, AttendanceEntity>> getTodayAttendance({
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, AttendanceActionEntity>> checkIn({
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, AttendanceActionEntity>> checkOut({
    double? latitude,
    double? longitude,
  });
}
