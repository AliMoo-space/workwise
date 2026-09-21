import 'package:workwise/features/leave/domain/entity/leave_history.dart';

class LeaveHistoryModel extends LeaveHistory {
  const LeaveHistoryModel({
    required super.type,
    required super.startDate,
    required super.endDate,
    required super.days,
    required super.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      type: json['type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      days: json['days'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'start_date': startDate,
      'end_date': endDate,
      'days': days,
      'status': status,
    };
  }
}
