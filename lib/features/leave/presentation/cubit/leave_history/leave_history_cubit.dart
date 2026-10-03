import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_history_use_case.dart';
import 'leave_history_state.dart';

class LeaveHistoryCubit extends Cubit<LeaveHistoryState> {
  LeaveHistoryCubit(this.getLeaveHistoryUseCase)
    : super(const LeaveHistoryInitial());

  final GetLeaveHistoryUseCase getLeaveHistoryUseCase;

  Future<void> getLeaveHistory() async {
    emit(const LeaveHistoryLoading());

    final result = await getLeaveHistoryUseCase();

    result.fold(
      (failure) {
        emit(LeaveHistoryFailure(failure.message));
      },
      (leaveHistory) {
        emit(LeaveHistorySuccess(leaveHistory));
      },
    );
  }
}
