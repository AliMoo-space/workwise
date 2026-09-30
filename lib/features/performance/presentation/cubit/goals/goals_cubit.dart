import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/performance/domain/goals/usecases/get_goal_details.dart';
import 'package:workwise/features/performance/domain/goals/usecases/get_goals.dart';

import 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this.getGoals, this.getGoalDetails) : super(GoalsInitial());

  final GetGoals getGoals;
  final GetGoalDetails getGoalDetails;

  Future<void> getGoalsData() async {
    emit(GoalsLoading());

    final result = await getGoals();

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(GoalsFailure(failure.message));
      },
      (goals) {
        if (isClosed) return;

        emit(GoalsSuccess(goals));
      },
    );
  }

  Future<void> getGoalDetailsData(int goalId) async {
    emit(GoalDetailsLoading());

    final result = await getGoalDetails(goalId);

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(GoalDetailsFailure(failure.message));
      },
      (goal) {
        if (isClosed) return;

        emit(GoalDetailsSuccess(goal));
      },
    );
  }
}
