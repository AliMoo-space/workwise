import 'package:equatable/equatable.dart';

abstract class LeaveRequestState extends Equatable {
  const LeaveRequestState();

  @override
  List<Object?> get props => [];
}

class LeaveRequestInitial extends LeaveRequestState {}

class LeaveRequestLoading extends LeaveRequestState {}

class LeaveRequestSuccess extends LeaveRequestState {}

class LeaveRequestFailure extends LeaveRequestState {
  final String message;

  const LeaveRequestFailure(this.message);

  @override
  List<Object?> get props => [message];
}
