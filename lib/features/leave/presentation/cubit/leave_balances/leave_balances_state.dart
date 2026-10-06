import 'package:equatable/equatable.dart';

import 'package:workwise/features/leave/domain/entity/leave_balance_entity.dart';

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
  final List<LeaveBalanceEntity> balances;

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
