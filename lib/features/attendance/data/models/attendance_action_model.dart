import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';

class AttendanceActionModel extends AttendanceActionEntity {
  AttendanceActionModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.checkIn,
    required super.checkOut,
    required super.status,
    required super.workedTime,
    required super.isException,
  });

  factory AttendanceActionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceActionModel(
      id: JsonHelper.required<int>(json, 'id'),
      userId: JsonHelper.required<int>(json, 'user_id'),
      date: JsonHelper.required<String>(json, 'date'),
      checkIn: JsonHelper.optional<String>(json, 'check_in'),
      checkOut: JsonHelper.optional<String>(json, 'check_out'),
      status: JsonHelper.required<String>(json, 'status'),
      workedTime: JsonHelper.optional<String>(json, 'worked_time'),
      isException: JsonHelper.required<bool>(json, 'is_exception'),
    );
  }
}

