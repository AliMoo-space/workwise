import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

class AttendanceActionEntity {
  final int id;
  final int userId;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String? workedTime;
  final bool isException;

  AttendanceActionEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.workedTime,
    required this.isException,
  });

  int? get workedSeconds => workedTime != null
      ? AttendanceEntity.parseWorkedTimeToSeconds(workedTime)
      : null;
}

