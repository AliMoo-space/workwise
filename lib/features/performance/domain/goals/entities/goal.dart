import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final int progressPercentage;
  final String targetDate;
  final String status;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.progressPercentage,
    required this.targetDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    targetValue,
    currentValue,
    progressPercentage,
    targetDate,
    status,
  ];
}
