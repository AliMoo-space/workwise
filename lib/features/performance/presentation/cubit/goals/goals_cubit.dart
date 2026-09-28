import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/performance/domain/goals/usecases/get_goals.dart';

import 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  final GetGoals getGoals;

  GoalsCubit(this.getGoals) : super(GoalsInitial());
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
}
