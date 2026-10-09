import 'package:equatable/equatable.dart';

final class CareerCoach extends Equatable {
  final List<Strength> strengths;
  final List<DevelopmentArea> developmentAreas;
  final List<DevelopmentPlan> developmentPlan;

  const CareerCoach({
    required this.strengths,
    required this.developmentAreas,
    required this.developmentPlan,
  });

  @override
  List<Object?> get props => [strengths, developmentAreas, developmentPlan];
}

final class Strength extends Equatable {
  final String title;
  final String description;

  const Strength({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

final class DevelopmentArea extends Equatable {
  final String title;
  final String description;

  const DevelopmentArea({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

final class DevelopmentPlan extends Equatable {
  final String action;
  final String suggestedTimeline;
  final String reason;
  final String measurableTarget;

  const DevelopmentPlan({
    required this.action,
    required this.suggestedTimeline,
    required this.reason,
    required this.measurableTarget,
  });

  @override
  List<Object?> get props => [
    action,
    suggestedTimeline,
    reason,
    measurableTarget,
  ];
}
