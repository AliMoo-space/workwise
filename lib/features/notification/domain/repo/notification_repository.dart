import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, NotificationPageEntity>> getNotifications({
    int? perPage,
  });

  Future<Either<Failure, int>> getUnreadNotificationsCount();

  Future<Either<Failure, void>> markNotificationAsRead(String id);

  Future<Either<Failure, void>> markAllNotificationsAsRead();

  Future<Either<Failure, void>> clearAllNotifications();

  Future<Either<Failure, void>> deleteNotification(String id);
}
