import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_history_use_case.dart';

import 'leave_history_state.dart';

class LeaveHistoryCubit extends Cubit<LeaveHistoryState> {
  final GetLeaveHistoryUseCase getLeaveHistoryUseCase;

  LeaveHistoryCubit(this.getLeaveHistoryUseCase)
    : super(const LeaveHistoryInitial());

  Future<void> getLeaveHistory() async {
    emit(const LeaveHistoryLoading());

    final result = await getLeaveHistoryUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(LeaveHistoryFailure(failure.message));
      },
      (leaveRequests) {
        emit(LeaveHistorySuccess(leaveRequests));
      },
    );
  }
}
