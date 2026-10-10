import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

class PerformanceModel extends PerformanceEntity {
  const PerformanceModel({
    required super.periodName,
    required super.score,
    required super.changeLabel,
    required super.tasksRate,
    required super.qualityRate,
    required super.attendanceRate,
    required super.performanceTrend,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    final overall = json['overall'] as Map<String, dynamic>;
    final atAGlance = json['at_a_glance'] as Map<String, dynamic>;
    final performanceTrend = json['performance_trend'] as List<dynamic>? ?? [];

    return PerformanceModel(
      periodName: json['period_name'] as String,
      score: (overall['score'] as num).toDouble(),
      changeLabel: overall['change_label'] as String,
      tasksRate: (atAGlance['tasks_rate'] as num).toDouble(),
      qualityRate: (atAGlance['quality_rate'] as num).toDouble(),
      attendanceRate: (atAGlance['attendance_rate'] as num).toDouble(),
      performanceTrend: performanceTrend
          .map(
            (item) =>
                PerformanceTrendModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PerformanceTrendModel extends PerformanceTrendEntity {
  const PerformanceTrendModel({
    required super.month,
    required super.overallScore,
  });

  factory PerformanceTrendModel.fromJson(Map<String, dynamic> json) {
    return PerformanceTrendModel(
      month: json['month'] as String,
      overallScore: (json['overall_score'] as num).toDouble(),
    );
  }
}
