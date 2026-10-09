import 'package:workwise/features/AIAssistant/domain/entities/career_coach.dart';

final class CareerCoachModel {
  final List<StrengthModel> strengths;
  final List<DevelopmentAreaModel> developmentAreas;
  final List<DevelopmentPlanModel> developmentPlan;

  const CareerCoachModel({
    required this.strengths,
    required this.developmentAreas,
    required this.developmentPlan,
  });

  factory CareerCoachModel.fromJson(Map<String, dynamic> json) {
    return CareerCoachModel(
      strengths: (json['strengths'] as List<dynamic>? ?? [])
          .map((item) => StrengthModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      developmentAreas: (json['development_areas'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DevelopmentAreaModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      developmentPlan: (json['development_plan'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DevelopmentPlanModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  CareerCoach toEntity() {
    return CareerCoach(
      strengths: strengths.map((strength) => strength.toEntity()).toList(),
      developmentAreas: developmentAreas
          .map((area) => area.toEntity())
          .toList(),
      developmentPlan: developmentPlan.map((plan) => plan.toEntity()).toList(),
    );
  }
}

final class StrengthModel {
  final String title;
  final String description;

  const StrengthModel({required this.title, required this.description});

  factory StrengthModel.fromJson(Map<String, dynamic> json) {
    return StrengthModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Strength toEntity() {
    return Strength(title: title, description: description);
  }
}

final class DevelopmentAreaModel {
  final String title;
  final String description;

  const DevelopmentAreaModel({required this.title, required this.description});

  factory DevelopmentAreaModel.fromJson(Map<String, dynamic> json) {
    return DevelopmentAreaModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  DevelopmentArea toEntity() {
    return DevelopmentArea(title: title, description: description);
  }
}

final class DevelopmentPlanModel {
  final String action;
  final String suggestedTimeline;
  final String reason;
  final String measurableTarget;

  const DevelopmentPlanModel({
    required this.action,
    required this.suggestedTimeline,
    required this.reason,
    required this.measurableTarget,
  });

  factory DevelopmentPlanModel.fromJson(Map<String, dynamic> json) {
    return DevelopmentPlanModel(
      action: json['action'] ?? '',
      suggestedTimeline: json['suggested_timeline'] ?? '',
      reason: json['reason'] ?? '',
      measurableTarget: json['measurable_target'] ?? '',
    );
  }

  DevelopmentPlan toEntity() {
    return DevelopmentPlan(
      action: action,
      suggestedTimeline: suggestedTimeline,
      reason: reason,
      measurableTarget: measurableTarget,
    );
  }
}
