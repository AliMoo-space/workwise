import 'package:workwise/features/leave/domain/entity/leave_history_entity.dart';

class LeaveHistoryModel extends LeaveHistoryEntity {
  const LeaveHistoryModel({
    required super.id,
    required super.startDate,
    required super.endDate,
    required super.days,
    required super.status,
    required super.name,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      id: json['id'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      days: json['days'] as int,
      status: json['status'] as String,
      name: (json['leave_type'] as Map<String, dynamic>)['name'] as String,
    );
  }
}
