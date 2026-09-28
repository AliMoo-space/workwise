import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

abstract class GoalsState {}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsSuccess extends GoalsState {
  final List<Goal> goals;

  GoalsSuccess(this.goals);
}

class GoalsFailure extends GoalsState {
  final String message;

  GoalsFailure(this.message);
}
