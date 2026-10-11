import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/performance/domain/performance/use_cases/get_performance_use_case.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_state.dart';

class PerformanceCubit extends Cubit<PerformanceState> {
  final GetPerformanceUseCase getPerformanceUseCase;

  PerformanceCubit({required this.getPerformanceUseCase})
    : super(PerformanceInitial());

  Future<void> getPerformance() async {
    emit(PerformanceLoading());

    final result = await getPerformanceUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(PerformanceFailure(failure.message));
      },
      (performance) {
        if (isClosed) return;

        emit(PerformanceSuccess(performance));
      },
    );
  }
}
