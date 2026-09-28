import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetValue,
    required super.currentValue,
    required super.progressPercentage,
    required super.targetDate,
    required super.status,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      targetValue: json['target_value'] as int,
      currentValue: json['current_value'] as int,
      progressPercentage: json['progress_percentage'] as int,
      targetDate: json['target_date'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_value': targetValue,
      'current_value': currentValue,
      'progress_percentage': progressPercentage,
      'target_date': targetDate,
      'status': status,
    };
  }
}
