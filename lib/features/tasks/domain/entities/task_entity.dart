import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final int progress;
  final int createdBy;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.progress,
    required this.createdBy,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        progress,
        createdBy,
        deadline,
        createdAt,
        updatedAt,
      ];
}
