import 'package:workwise/features/notification/domain/repo/notification_repo.dart';

class ShowNotification {
  final NotificationRepo _notificationRepo;

  ShowNotification(this._notificationRepo);
  Future<void> call({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notificationRepo.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }
}
