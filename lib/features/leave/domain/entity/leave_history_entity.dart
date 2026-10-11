import 'package:equatable/equatable.dart';

class LeaveHistoryEntity extends Equatable {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final int days;
  final String status;
  final String createdAt;

  const LeaveHistoryEntity({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    startDate,
    endDate,
    days,
    status,
    createdAt,
  ];
}
