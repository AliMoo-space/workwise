abstract class NotificationRepo {
  Future<void> initializeNotification();

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  });
}
