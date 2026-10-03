import 'package:equatable/equatable.dart';

class LeaveHistoryEntity extends Equatable {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int days;
  final String status;
  final String name;

  const LeaveHistoryEntity({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.name,
  });

  @override
  List<Object?> get props => [id, startDate, endDate, days, status, name];
}
