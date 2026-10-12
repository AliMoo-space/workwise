import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/notification/data/models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<NotificationPageModel> getNotifications({int? perPage});

  Future<int> getUnreadNotificationsCount();

  Future<void> markNotificationAsRead(String id);

  Future<void> markAllNotificationsAsRead();

  Future<void> clearAllNotifications();

  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<NotificationPageModel> getNotifications({int? perPage}) async {
    final response = await apiConsumer.get(
      ApiEndpoints.notifications,
      queryParameters: perPage == null ? null : {'per_page': perPage},
    );
    final responseData = response.data;
    if (responseData is! Map || responseData['data'] is! Map) {
      throw const ServerException(
        'Invalid response format: missing data field',
      );
    }

    return NotificationPageModel.fromJson(
      Map<String, dynamic>.from(responseData['data'] as Map),
    );
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    final response = await apiConsumer.get(
      ApiEndpoints.unreadNotificationsCount,
    );
    final responseData = response.data;
    if (responseData is! Map ||
        responseData['data'] is! Map ||
        (responseData['data'] as Map)['unread_count'] is! int) {
      throw const ServerException(
        'Invalid response format: missing unread count',
      );
    }
    return (responseData['data'] as Map)['unread_count'] as int;
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    await apiConsumer.patch(ApiEndpoints.markNotificationAsRead(id));
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    await apiConsumer.patch(ApiEndpoints.markAllNotificationsAsRead);
  }

  @override
  Future<void> clearAllNotifications() async {
    await apiConsumer.delete(ApiEndpoints.clearAllNotifications);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await apiConsumer.delete(ApiEndpoints.deleteNotification(id));
  }
}
