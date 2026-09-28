import 'package:equatable/equatable.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

abstract class PerformanceState extends Equatable {
  const PerformanceState();

  @override
  List<Object?> get props => [];
}

class PerformanceInitial extends PerformanceState {}

class PerformanceLoading extends PerformanceState {}

class PerformanceSuccess extends PerformanceState {
  final PerformanceEntity performance;

  const PerformanceSuccess(this.performance);

  @override
  List<Object?> get props => [performance];
}

class PerformanceFailure extends PerformanceState {
  final String message;

  const PerformanceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
