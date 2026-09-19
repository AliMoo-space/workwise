import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workwise/features/notification/domain/repo/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationRepoImpl({
    required this._notificationsPlugin,
  });

  @override
  Future<void> initializeNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
    );

    const channel = AndroidNotificationChannel(
      'general_channel',
      'General Notifications',
      description: 'General notifications for WorkWise',
      importance: Importance.high,
    );

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'general_channel',
        'General Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}