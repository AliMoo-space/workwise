import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/entity/leave_balance.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_balances.dart';

part 'leave_balances_state.dart';

class LeaveBalancesCubit extends Cubit<LeaveBalancesState> {
  final GetLeaveBalances getLeaveBalances;

  LeaveBalancesCubit({required this.getLeaveBalances})
    : super(const LeaveBalancesInitial());

  Future<void> getBalances() async {
    emit(const LeaveBalancesLoading());

    final result = await getLeaveBalances();

    result.fold(
      (failure) => emit(LeaveBalancesFailure(failure.message)),
      (balances) => emit(LeaveBalancesSuccess(balances)),
    );
  }
}
