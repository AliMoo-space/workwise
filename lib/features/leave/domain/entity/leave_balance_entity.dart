import 'package:equatable/equatable.dart';

class LeaveBalanceEntity extends Equatable {
  const LeaveBalanceEntity({
    required this.id,
    required this.leaveTypeName,
    required this.allocatedDays,
    required this.usedDays,
    required this.remainingDays,
  });

  final int id;
  final String leaveTypeName;
  final int allocatedDays;
  final int usedDays;
  final int remainingDays;

  double get progress {
    if (allocatedDays == 0) return 0;
    return remainingDays / allocatedDays;
  }

  @override
  List<Object?> get props => [
    id,
    leaveTypeName,
    allocatedDays,
    usedDays,
    remainingDays,
  ];
}
