import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/leave/data/datasourse/leave_remote_data_source.dart';
import 'package:workwise/features/leave/data/models/leave_request_model.dart';
import 'package:workwise/features/leave/domain/entity/leave_request_entity.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;

  LeaveRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createLeaveRequest(
    LeaveRequestEntity request,
  ) async {
    try {
      await remoteDataSource.createLeaveRequest(
        LeaveRequestModel(
          leaveTypeId: request.leaveTypeId,
          startDate: request.startDate,
          endDate: request.endDate,
          reason: request.reason,
          image: request.image,
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
