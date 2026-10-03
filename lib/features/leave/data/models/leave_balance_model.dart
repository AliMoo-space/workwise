import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

class LeaveBalanceModel extends LeaveBalanceEntity {
  const LeaveBalanceModel({
    required super.id,
    required super.leaveTypeName,
    required super.allocatedDays,
    required super.usedDays,
    required super.remainingDays,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      id: json['id'] as int,
      leaveTypeName: json['leave_type']['name'] as String,
      allocatedDays: json['allocated_days'] as int,
      usedDays: json['used_days'] as int,
      remainingDays: json['remaining_days'] as int,
    );
  }
}
