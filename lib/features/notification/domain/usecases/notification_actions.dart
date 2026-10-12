import 'package:dartz/dartz.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/notification/domain/repo/notification_repository.dart';

class GetUnreadNotificationsCount {
  const GetUnreadNotificationsCount(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, int>> call() {
    return _repository.getUnreadNotificationsCount();
  }
}

class MarkNotificationAsRead {
  const MarkNotificationAsRead(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, void>> call(String id) {
    return _repository.markNotificationAsRead(id);
  }
}

class MarkAllNotificationsAsRead {
  const MarkAllNotificationsAsRead(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.markAllNotificationsAsRead();
  }
}

class ClearAllNotifications {
  const ClearAllNotifications(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.clearAllNotifications();
  }
}

class DeleteNotification {
  const DeleteNotification(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteNotification(id);
  }
}
