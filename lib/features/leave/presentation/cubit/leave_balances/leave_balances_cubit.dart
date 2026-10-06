import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_balances_use_case.dart';

import 'leave_balances_state.dart';

class LeaveBalancesCubit extends Cubit<LeaveBalancesState> {
  final GetLeaveBalancesUseCase getLeaveBalancesUseCase;

  LeaveBalancesCubit({required this.getLeaveBalancesUseCase})
    : super(const LeaveBalancesInitial());

  Future<void> getLeaveBalances() async {
    emit(const LeaveBalancesLoading());

    final result = await getLeaveBalancesUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(LeaveBalancesFailure(failure.message));
      },
      (balances) {
        emit(LeaveBalancesSuccess(balances));
      },
    );
  }
}
