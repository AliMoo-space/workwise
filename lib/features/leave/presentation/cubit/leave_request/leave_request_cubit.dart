import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';
import 'package:workwise/features/leave/domain/usecase/create_leave_request_use_case.dart';

import 'leave_request_state.dart';

class LeaveRequestCubit extends Cubit<LeaveRequestState> {
  final CreateLeaveRequestUseCase createLeaveRequestUseCase;

  LeaveRequestCubit(this.createLeaveRequestUseCase)
    : super(LeaveRequestInitial());

  Future<void> createLeaveRequest(LeaveRequestEntity request) async {
    emit(LeaveRequestLoading());

    final result = await createLeaveRequestUseCase(request);

    result.fold(
      (failure) {
        emit(LeaveRequestFailure(failure.message));
      },
      (_) {
        emit(LeaveRequestSuccess());
      },
    );
  }
}
