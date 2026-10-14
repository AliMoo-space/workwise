import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/features/notification/data/datasource/notification_remote_data_source.dart';

class FakeNotificationApiConsumer implements ApiConsumer {
  String? lastGetPath;
  Map<String, dynamic>? lastGetQuery;
  String? lastPostPath;
  dynamic lastPostData;
  String? lastPatchPath;
  String? lastDeletePath;
  dynamic responseData;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastGetPath = path;
    lastGetQuery = queryParameters;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPostPath = path;
    lastPostData = data;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPatchPath = path;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastDeletePath = path;
    return Response(
      data: responseData,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  late FakeNotificationApiConsumer fakeApiConsumer;
  late NotificationRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeApiConsumer = FakeNotificationApiConsumer();
    dataSource = NotificationRemoteDataSourceImpl(apiConsumer: fakeApiConsumer);
  });

  group('updateFcmToken', () {
    test(
      'sends POST request to /api/notifications/fcm-token with fcm_token body',
      () async {
        fakeApiConsumer.responseData = {
          'success': true,
          'message': 'FCM Token updated successfully',
          'data': null,
        };

        await dataSource.updateFcmToken('c-test-token:APA91bF123');

        expect(fakeApiConsumer.lastPostPath, ApiEndpoints.updateFcmToken);
        expect(fakeApiConsumer.lastPostPath, '/api/notifications/fcm-token');
        expect(fakeApiConsumer.lastPostData, {
          'fcm_token': 'c-test-token:APA91bF123',
        });
      },
    );
  });

  group('getNotifications', () {
    test('parses NotificationPageModel from response data', () async {
      fakeApiConsumer.responseData = {
        'success': true,
        'data': {
          'notifications': [
            {
              'id': 'notif-1',
              'type': 'task_assigned',
              'title': 'New Task',
              'body': 'You have a new task',
              'metadata': {'task_id': 10},
              'is_read': false,
              'created_at': '2026-10-11T10:00:00Z',
            },
          ],
          'links': {
            'first': 'https://example.com?page=1',
            'last': 'https://example.com?page=1',
            'prev': null,
            'next': null,
          },
          'meta': {
            'current_page': 1,
            'from': 1,
            'last_page': 1,
            'links': <Map<String, dynamic>>[],
            'per_page': 15,
            'to': 1,
            'total': 1,
          },
        },
      };

      final page = await dataSource.getNotifications(perPage: 15);

      expect(fakeApiConsumer.lastGetPath, ApiEndpoints.notifications);
      expect(fakeApiConsumer.lastGetQuery, {'per_page': 15});
      expect(page.notifications.length, 1);
      expect(page.notifications.first.id, 'notif-1');
    });

    test(
      'parses NotificationModel when title and body are inside nested data object',
      () async {
        fakeApiConsumer.responseData = {
          'success': true,
          'data': {
            'notifications': [
              {
                'id': '9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d',
                'type': r'App\Notifications\NewTaskNotification',
                'data': {
                  'title': 'New Task',
                  'body': 'You have been assigned a new task.',
                  'task_id': 10,
                },
                'read_at': null,
                'is_read': false,
                'created_at': '2026-09-17 21:00:00',
              },
            ],
            'links': <String, dynamic>{},
            'meta': <String, dynamic>{},
          },
        };

        final page = await dataSource.getNotifications();
        final item = page.notifications.single;

        expect(item.title, 'New Task');
        expect(item.body, 'You have been assigned a new task.');
        expect(item.metadata, {'task_id': 10});
      },
    );

    test('throws ServerException when data field is missing', () async {
      fakeApiConsumer.responseData = {'success': true};

      expect(
        () => dataSource.getNotifications(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
