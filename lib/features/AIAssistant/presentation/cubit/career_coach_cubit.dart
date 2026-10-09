import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:workwise/features/AIAssistant/domain/usecases/get_career_coach.dart';

import 'career_coach_state.dart';

class CareerCoachCubit extends Cubit<CareerCoachState> {
  final GetCareerCoach getCareerCoach;

  CareerCoachCubit({required this.getCareerCoach})
    : super(CareerCoachInitial());

  Future<void> getCareerCoachData(Map<String, dynamic> body) async {
    emit(CareerCoachLoading());

    final result = await getCareerCoach(body);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(CareerCoachFailure(failure.message));
      },
      (careerCoach) {
        if (isClosed) return;

        emit(CareerCoachSuccess(careerCoach));
      },
    );
  }
}
