import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/exception.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/notification/data/datasource/notification_remote_data_source.dart';
import 'package:workwise/features/notification/data/models/notification_model.dart';
import 'package:workwise/features/notification/data/repo/notification_repository_impl.dart';

class FakeNotificationRemoteDataSource implements NotificationRemoteDataSource {
  String? lastUpdatedFcmToken;
  AppException? exceptionToThrow;

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    lastUpdatedFcmToken = fcmToken;
  }

  @override
  Future<NotificationPageModel> getNotifications({int? perPage}) {
    throw UnimplementedError();
  }

  @override
  Future<int> getUnreadNotificationsCount() {
    throw UnimplementedError();
  }

  @override
  Future<void> markNotificationAsRead(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearAllNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNotification(String id) {
    throw UnimplementedError();
  }
}

void main() {
  late FakeNotificationRemoteDataSource fakeRemoteDataSource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    fakeRemoteDataSource = FakeNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(
      remoteDataSource: fakeRemoteDataSource,
    );
  });

  group('updateFcmToken', () {
    test('returns Right(null) when remoteDataSource succeeds', () async {
      final result = await repository.updateFcmToken('fcm-token-123');

      expect(result, const Right<Failure, void>(null));
      expect(fakeRemoteDataSource.lastUpdatedFcmToken, 'fcm-token-123');
    });

    test('maps UnauthorizedException to UnauthorizedFailure', () async {
      fakeRemoteDataSource.exceptionToThrow = const UnauthorizedException(
        'Unauthenticated',
      );

      final result = await repository.updateFcmToken('fcm-token-123');

      expect(
        result,
        const Left<Failure, void>(UnauthorizedFailure('Unauthenticated')),
      );
    });

    test('maps ValidationException to ValidationFailure', () async {
      fakeRemoteDataSource.exceptionToThrow = const ValidationException(
        'The fcm_token field is required.',
      );

      final result = await repository.updateFcmToken('');

      expect(
        result,
        const Left<Failure, void>(
          ValidationFailure('The fcm_token field is required.'),
        ),
      );
    });
  });
}
