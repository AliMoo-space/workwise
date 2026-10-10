import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_history_entity.dart';
import 'package:workwise/features/attendance/domain/usecases/get_attendance_history.dart';

part 'attendance_history_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  AttendanceHistoryCubit({required this.getAttendanceHistory})
    : super(const AttendanceHistoryInitial());

  final GetAttendanceHistory getAttendanceHistory;
  int _requestId = 0;

  Future<void> loadHistory({int? month, int? year, int? perPage}) async {
    final requestId = ++_requestId;
    emit(const AttendanceHistoryLoading());
    final result = await getAttendanceHistory(
      month: month,
      year: year,
      perPage: perPage,
    );
    if (requestId != _requestId) return;
    result.fold(
      (failure) => emit(AttendanceHistoryFailure(failure.message)),
      (history) => emit(AttendanceHistorySuccess(history)),
    );
  }
}
