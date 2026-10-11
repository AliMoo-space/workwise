import 'package:equatable/equatable.dart';

class PerformanceEntity extends Equatable {
  final String periodName;
  final double score;
  final String changeLabel;
  final double tasksRate;
  final double qualityRate;
  final double attendanceRate;
  final List<PerformanceTrendEntity> performanceTrend;

  const PerformanceEntity({
    required this.periodName,
    required this.score,
    required this.changeLabel,
    required this.tasksRate,
    required this.qualityRate,
    required this.attendanceRate,
    required this.performanceTrend,
  });

  @override
  List<Object?> get props => [
    periodName,
    score,
    changeLabel,
    tasksRate,
    qualityRate,
    attendanceRate,
    performanceTrend,
  ];
}

class PerformanceTrendEntity extends Equatable {
  final String month;
  final double overallScore;

  const PerformanceTrendEntity({
    required this.month,
    required this.overallScore,
  });

  @override
  List<Object?> get props => [month, overallScore];
}
