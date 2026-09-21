import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:workwise/features/leave/domain/entity/leave_history.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_history.dart';

part 'leave_history_state.dart';

class LeaveHistoryCubit extends Cubit<LeaveHistoryState> {
  final GetLeaveHistory getLeaveHistory;

  LeaveHistoryCubit({required this.getLeaveHistory})
    : super(const LeaveHistoryInitial());

  Future<void> getHistory() async {
    emit(const LeaveHistoryLoading());

    final result = await getLeaveHistory();

    result.fold(
      (failure) => emit(LeaveHistoryFailure(message: failure.message)),
      (history) => emit(LeaveHistorySuccess(history: history)),
    );
  }
}
