import '../../domain/entity/leave_history_entity.dart';

class LeaveHistoryModel extends LeaveHistoryEntity {
  const LeaveHistoryModel({
    required super.id,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.days,
    required super.status,
    required super.createdAt,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    final leaveType = json['leave_type'] as Map<String, dynamic>?;

    return LeaveHistoryModel(
      id: json['id']?.toString() ?? '',
      name: leaveType?['name']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      days: json['days'] is int
          ? json['days'] as int
          : int.tryParse(json['days']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
