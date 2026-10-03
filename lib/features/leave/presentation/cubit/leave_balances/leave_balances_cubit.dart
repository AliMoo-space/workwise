import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_balances_use_case.dart';

import 'leave_balances_state.dart';

class LeaveBalancesCubit extends Cubit<LeaveBalancesState> {
  LeaveBalancesCubit(this.getLeaveBalancesUseCase)
    : super(const LeaveBalancesInitial());

  final GetLeaveBalancesUseCase getLeaveBalancesUseCase;

  Future<void> getLeaveBalances() async {
    emit(const LeaveBalancesLoading());

    final result = await getLeaveBalancesUseCase();

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
