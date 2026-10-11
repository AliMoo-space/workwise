import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetDate,
    required super.status,
    required super.createdAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: JsonHelper.required<int>(json, 'id'),
      title: JsonHelper.required<String>(json, 'title'),
      description: JsonHelper.required<String>(json, 'description'),
      targetDate: JsonHelper.required<String>(json, 'target_date'),
      status: JsonHelper.required<String>(json, 'status'),
      createdAt: JsonHelper.required<String>(json, 'created_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_date': targetDate,
      'status': status,
      'created_at': createdAt,
    };
  }
}
