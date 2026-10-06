import 'package:equatable/equatable.dart';

class GoalDetailsEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String targetDate;
  final String status;
  final String createdAt;

  const GoalDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    targetDate,
    status,
    createdAt,
  ];
}
