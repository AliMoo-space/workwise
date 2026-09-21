import 'package:workwise/features/leave/domain/entity/leave_balance.dart';

class LeaveBalanceModel extends LeaveBalance {
  const LeaveBalanceModel({
    required super.type,
    required super.usedDays,
    required super.totalDays,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      type: json['type'] as String,
      usedDays: json['used_days'] as int,
      totalDays: json['total_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'used_days': usedDays, 'total_days': totalDays};
  }
}
