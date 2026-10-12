import 'package:equatable/equatable.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final TasksResponseModel response;
  final bool isLoadingMore;

  const TasksLoaded({
    required this.response,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [response, isLoadingMore];

  TasksLoaded copyWith({
    TasksResponseModel? response,
    bool? isLoadingMore,
  }) {
    return TasksLoaded(
      response: response ?? this.response,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class TasksError extends TasksState {
  final Failure failure;

  const TasksError({required this.failure});

  String get message => failure.message;

  @override
  List<Object?> get props => [failure];
}
