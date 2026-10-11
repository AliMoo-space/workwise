import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';

class CreateLeaveRequestUseCase {
  final LeaveRepository repository;

  CreateLeaveRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(LeaveRequestEntity request) {
    return repository.createLeaveRequest(request);
  }
}
