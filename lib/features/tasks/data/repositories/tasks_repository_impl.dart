import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/network/network_info.dart';
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:workwise/features/tasks/data/models/task_model.dart';
import 'package:workwise/features/tasks/data/models/task_submission_model.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TasksResponseModel>> getTasks({
    String? lang,
    String? status,
    String? priority,
    String? deadlineFrom,
    String? deadlineTo,
    int? perPage,
    int? page,
  }) async {
    try {
      final result = await remoteDataSource.getTasks(
        lang: lang,
        status: status,
        priority: priority,
        deadlineFrom: deadlineFrom,
        deadlineTo: deadlineTo,
        perPage: perPage,
        page: page,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> updateTaskProgress({
    required int taskId,
    required int progress,
    String? lang,
  }) async {
    try {
      final result = await remoteDataSource.updateTaskProgress(
        taskId: taskId,
        progress: progress,
        lang: lang,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskModel>> updateTaskStatus({
    required int taskId,
    required String status,
    String? lang,
  }) async {
    try {
      final result = await remoteDataSource.updateTaskStatus(
        taskId: taskId,
        status: status,
        lang: lang,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskSubmissionResponseModel>> submitTask({
    required int taskId,
    required String note,
    List<String>? filePaths,
    String? lang,
  }) async {
    try {
      final result = await remoteDataSource.submitTask(
        taskId: taskId,
        note: note,
        filePaths: filePaths,
        lang: lang,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskSubmissionResponseModel>> getSubmissionDetails({
    required int submissionId,
    String? lang,
  }) async {
    try {
      final result = await remoteDataSource.getSubmissionDetails(
        submissionId: submissionId,
        lang: lang,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubmissionAttachment>> addSubmissionAttachment({
    required int submissionId,
    required String filePath,
    String? lang,
  }) async {
    try {
      final result = await remoteDataSource.addSubmissionAttachment(
        submissionId: submissionId,
        filePath: filePath,
        lang: lang,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
