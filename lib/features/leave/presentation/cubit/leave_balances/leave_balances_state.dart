import 'package:equatable/equatable.dart';

import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

sealed class LeaveBalancesState extends Equatable {
  const LeaveBalancesState();

  @override
  List<Object?> get props => [];
}

final class LeaveBalancesInitial extends LeaveBalancesState {
  const LeaveBalancesInitial();
}

final class LeaveBalancesLoading extends LeaveBalancesState {
  const LeaveBalancesLoading();
}

final class LeaveBalancesSuccess extends LeaveBalancesState {
  const LeaveBalancesSuccess(this.balances);

  final List<LeaveBalanceEntity> balances;

  @override
  List<Object?> get props => [balances];
}

final class LeaveBalancesFailure extends LeaveBalancesState {
  const LeaveBalancesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
