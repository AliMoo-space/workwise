import 'package:flutter/foundation.dart';

enum TaskFilter { all, inProgress, underReview, completed }

enum TaskStatus { inProgress, underReview, completed }

enum TaskPriority { low, medium, high, urgent }

@immutable
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.managerName,
    required this.priority,
    required this.deadline,
    required this.progress,
    required this.status,
    this.description,
    this.feedback,
  });

  final String id;
  final String title;
  final String managerName;
  final TaskPriority priority;
  final DateTime deadline;
  final int progress;
  final TaskStatus status;
  final String? description;
  final String? feedback;

  Task copyWith({
    int? progress,
    TaskStatus? status,
    String? feedback,
  }) =>
      Task(
        id: id,
        title: title,
        managerName: managerName,
        priority: priority,
        deadline: deadline,
        progress: progress ?? this.progress,
        status: status ?? this.status,
        description: description,
        feedback: feedback ?? this.feedback,
      );
}

@immutable
class TaskAttachment {
  const TaskAttachment({
    required this.name,
    required this.sizeInBytes,
    this.localPath,
    this.remoteUrl,
  });

  final String name;
  final int sizeInBytes;
  final String? localPath;
  final String? remoteUrl;
}
