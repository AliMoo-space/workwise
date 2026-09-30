import 'package:workwise/features/performance/domain/goals/entities/goal.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal_details_entity.dart';

abstract class GoalsState {}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsSuccess extends GoalsState {
  GoalsSuccess(this.goals);

  final List<Goal> goals;
}

class GoalsFailure extends GoalsState {
  GoalsFailure(this.message);

  final String message;
}

// =============================================
// Goal Details
// =============================================

class GoalDetailsLoading extends GoalsState {}

class GoalDetailsSuccess extends GoalsState {
  GoalDetailsSuccess(this.goal);

  final GoalDetailsEntity goal;
}

class GoalDetailsFailure extends GoalsState {
  GoalDetailsFailure(this.message);

  final String message;
}
