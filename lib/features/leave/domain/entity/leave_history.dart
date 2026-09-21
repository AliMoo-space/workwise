import 'package:equatable/equatable.dart';

class LeaveHistory extends Equatable {
  final String type;
  final String startDate;
  final String endDate;
  final int days;
  final String status;

  const LeaveHistory({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
  });

  @override
  List<Object> get props => [type, startDate, endDate, days, status];
}
