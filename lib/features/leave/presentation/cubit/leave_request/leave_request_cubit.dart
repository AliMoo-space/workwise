import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';
import 'package:workwise/features/leave/domain/usecase/create_leave_request_use_case.dart';

import 'leave_request_state.dart';

class LeaveRequestCubit extends Cubit<LeaveRequestState> {
  final CreateLeaveRequestUseCase createLeaveRequestUseCase;

  LeaveRequestCubit({required this.createLeaveRequestUseCase})
    : super(const LeaveRequestInitial());

  Future<void> createLeaveRequest(LeaveRequestEntity request) async {
    emit(const LeaveRequestLoading());

    final result = await createLeaveRequestUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(LeaveRequestFailure(failure.message));
      },
      (_) {
        emit(const LeaveRequestSuccess());
      },
    );
  }
}
