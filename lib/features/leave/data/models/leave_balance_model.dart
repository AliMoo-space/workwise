import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

class LeaveBalanceModel extends LeaveBalanceEntity {
  const LeaveBalanceModel({
    required super.name,
    required super.remainingDays,
    required super.allocatedDays,
    required super.usedDays,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    final leaveType = json['leave_type'] as Map<String, dynamic>?;

    return LeaveBalanceModel(
      name: leaveType?['name']?.toString() ?? '',
      remainingDays: (json['remaining_days'] as num?)?.toDouble() ?? 0,
      allocatedDays: (json['allocated_days'] as num?)?.toDouble() ?? 0,
      usedDays: (json['used_days'] as num?)?.toDouble() ?? 0,
    );
  }
}
