import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/notification/data/datasource/notification_remote_data_source.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';
import 'package:workwise/features/notification/domain/repo/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({required this.remoteDataSource});

  final NotificationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, NotificationPageEntity>> getNotifications({
    int? perPage,
  }) async {
    try {
      return Right(await remoteDataSource.getNotifications(perPage: perPage));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async {
    try {
      return Right(await remoteDataSource.getUnreadNotificationsCount());
    } on AppException catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String id) async {
    try {
      await remoteDataSource.markNotificationAsRead(id);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() async {
    try {
      await remoteDataSource.markAllNotificationsAsRead();
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    try {
      await remoteDataSource.clearAllNotifications();
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapFailure(e));
    }
  }

  Failure _mapFailure(AppException exception) {
    return switch (exception) {
      UnauthorizedException() => UnauthorizedFailure(exception.message),
      ValidationException() => ValidationFailure(exception.message),
      NetworkException() => NetworkFailure(exception.message),
      ServerException() => ServerFailure(exception.message),
      _ => ServerFailure(exception.message),
    };
  }
}
