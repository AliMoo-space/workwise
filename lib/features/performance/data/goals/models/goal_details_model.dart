import 'package:workwise/features/performance/domain/goals/entities/goal_details_entity.dart';

class GoalDetailsModel extends GoalDetailsEntity {
  const GoalDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetValue,
    required super.currentValue,
    required super.progressPercentage,
    required super.targetDate,
    required super.status,
    required super.createdAt,
  });

  factory GoalDetailsModel.fromJson(Map<String, dynamic> json) {
    return GoalDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      targetValue: (json['target_value'] as num).toInt(),
      currentValue: (json['current_value'] as num).toInt(),
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      targetDate: json['target_date'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
