import 'package:equatable/equatable.dart';

class LeaveBalanceEntity extends Equatable {
  final String name;
  final double remainingDays;
  final double allocatedDays;
  final double usedDays;

  const LeaveBalanceEntity({
    required this.name,
    required this.remainingDays,
    required this.allocatedDays,
    required this.usedDays,
  });

  @override
  List<Object?> get props => [name, remainingDays, allocatedDays, usedDays];
}
