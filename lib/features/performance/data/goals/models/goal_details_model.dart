import 'package:workwise/core/utils/json_helper.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal_details_entity.dart';

class GoalDetailsModel extends GoalDetailsEntity {
  const GoalDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetDate,
    required super.status,
    required super.createdAt,
  });

  factory GoalDetailsModel.fromJson(Map<String, dynamic> json) {
    return GoalDetailsModel(
      id: JsonHelper.required<int>(json, 'id'),
      title: JsonHelper.required<String>(json, 'title'),
      description: JsonHelper.required<String>(json, 'description'),
      targetDate: JsonHelper.required<String>(json, 'target_date'),
      status: JsonHelper.required<String>(json, 'status'),
      createdAt: JsonHelper.required<String>(json, 'created_at'),
    );
  }
}
