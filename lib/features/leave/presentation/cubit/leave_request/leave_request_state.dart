import 'package:equatable/equatable.dart';

abstract class LeaveRequestState extends Equatable {
  const LeaveRequestState();

  @override
  List<Object?> get props => [];
}

class LeaveRequestInitial extends LeaveRequestState {
  const LeaveRequestInitial();
}

class LeaveRequestLoading extends LeaveRequestState {
  const LeaveRequestLoading();
}

class LeaveRequestSuccess extends LeaveRequestState {
  const LeaveRequestSuccess();
}

class LeaveRequestFailure extends LeaveRequestState {
  final String message;

  const LeaveRequestFailure(this.message);

  @override
  List<Object?> get props => [message];
}
