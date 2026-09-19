import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final String type;
  final int usedDays;
  final int totalDays;

  const LeaveBalance({
    required this.type,
    required this.usedDays,
    required this.totalDays,
  });

  int get remainingDays => totalDays - usedDays;

  double get progress {
    if (totalDays == 0) return 0;
    return usedDays / totalDays;
  }

  @override
  List<Object?> get props => [type, usedDays, totalDays];
}
