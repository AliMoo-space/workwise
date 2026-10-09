import 'package:equatable/equatable.dart';

import 'package:workwise/features/AIAssistant/domain/entities/career_coach.dart';

abstract class CareerCoachState extends Equatable {
  const CareerCoachState();

  @override
  List<Object?> get props => [];
}

class CareerCoachInitial extends CareerCoachState {}

class CareerCoachLoading extends CareerCoachState {}

class CareerCoachSuccess extends CareerCoachState {
  final CareerCoach careerCoach;

  const CareerCoachSuccess(this.careerCoach);

  @override
  List<Object?> get props => [careerCoach];
}

class CareerCoachFailure extends CareerCoachState {
  final String message;

  const CareerCoachFailure(this.message);

  @override
  List<Object?> get props => [message];
}
