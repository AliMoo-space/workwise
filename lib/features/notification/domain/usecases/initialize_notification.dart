import 'package:workwise/features/notification/domain/repo/notification_repo.dart';

class InitializeNotification {
  final NotificationRepo _notificationRepo;

  InitializeNotification(this._notificationRepo);
  Future<void> call() async {
    await _notificationRepo.initializeNotification();
  }
}