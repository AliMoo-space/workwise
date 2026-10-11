import 'package:equatable/equatable.dart';

class LeaveRequestEntity extends Equatable {
  final int leaveTypeId;
  final String startDate;
  final String endDate;
  final String reason;
  final String? image;

  const LeaveRequestEntity({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.image,
  });

  @override
  List<Object?> get props => [leaveTypeId, startDate, endDate, reason, image];
}
