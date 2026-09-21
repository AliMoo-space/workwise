part of 'leave_balances_cubit.dart';

abstract class LeaveBalancesState extends Equatable {
  const LeaveBalancesState();

  @override
  List<Object?> get props => [];
}

class LeaveBalancesInitial extends LeaveBalancesState {
  const LeaveBalancesInitial();
}

class LeaveBalancesLoading extends LeaveBalancesState {
  const LeaveBalancesLoading();
}

class LeaveBalancesSuccess extends LeaveBalancesState {
  final List<LeaveBalance> balances;

  const LeaveBalancesSuccess(this.balances);

  @override
  List<Object?> get props => [balances];
}

class LeaveBalancesFailure extends LeaveBalancesState {
  final String message;

  const LeaveBalancesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
