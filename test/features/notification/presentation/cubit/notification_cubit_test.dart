import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';
import 'package:workwise/features/notification/domain/repo/notification_repository.dart';
import 'package:workwise/features/notification/domain/usecases/get_notifications.dart';
import 'package:workwise/features/notification/domain/usecases/notification_actions.dart';
import 'package:workwise/features/notification/presentation/cubit/notification_cubit.dart';

class FakeNotificationRepository implements NotificationRepository {
  Either<Failure, NotificationPageEntity>? notificationsResult;
  Either<Failure, int>? unreadCountResult;
  int getNotificationsCallCount = 0;
  int markReadCallCount = 0;

  @override
  Future<Either<Failure, NotificationPageEntity>> getNotifications({
    int? perPage,
  }) async {
    getNotificationsCallCount++;
    return notificationsResult!;
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() async {
    return unreadCountResult!;
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String id) async {
    markReadCallCount++;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(String fcmToken) async {
    return const Right(null);
  }
}

NotificationPageEntity _buildPage(List<NotificationEntity> items) {
  return NotificationPageEntity(
    notifications: items,
    links: const NotificationLinksEntity(
      first: null,
      last: null,
      prev: null,
      next: null,
    ),
    meta: NotificationMetaEntity(
      currentPage: 1,
      from: 1,
      lastPage: 1,
      links: const [],
      perPage: 15,
      to: items.length,
      total: items.length,
    ),
  );
}

void main() {
  late FakeNotificationRepository fakeRepo;
  late StreamController<void> foregroundStreamController;
  late bool isUserAuthenticated;
  late NotificationCubit cubit;

  setUp(() {
    fakeRepo = FakeNotificationRepository();
    foregroundStreamController = StreamController<void>.broadcast();
    isUserAuthenticated = true;
    cubit = NotificationCubit(
      getNotifications: GetNotifications(fakeRepo),
      getUnreadNotificationsCount: GetUnreadNotificationsCount(fakeRepo),
      markNotificationAsRead: MarkNotificationAsRead(fakeRepo),
      markAllNotificationsAsRead: MarkAllNotificationsAsRead(fakeRepo),
      clearAllNotifications: ClearAllNotifications(fakeRepo),
      deleteNotification: DeleteNotification(fakeRepo),
      foregroundNotificationStream: foregroundStreamController.stream,
      isAuthenticated: () async => isUserAuthenticated,
    );
  });

  tearDown(() async {
    await cubit.close();
    await foregroundStreamController.close();
  });

  group('refreshNotificationsSilently & polling', () {
    test(
      'updates NotificationSuccess without emitting NotificationLoading skeleton',
      () async {
        final initialPage = _buildPage(const [
          NotificationEntity(
            id: '1',
            type: 'task',
            title: 'Task 1',
            body: 'Body 1',
            metadata: {},
            isRead: false,
            createdAt: '2026-10-11T10:00:00Z',
          ),
        ]);
        fakeRepo.notificationsResult = Right(initialPage);
        fakeRepo.unreadCountResult = const Right(1);

        await cubit.loadNotifications();
        expect(cubit.state, isA<NotificationSuccess>());

        final updatedPage = _buildPage(const [
          NotificationEntity(
            id: '2',
            type: 'task',
            title: 'Task 2',
            body: 'Body 2',
            metadata: {},
            isRead: false,
            createdAt: '2026-10-11T10:05:00Z',
          ),
          NotificationEntity(
            id: '1',
            type: 'task',
            title: 'Task 1',
            body: 'Body 1',
            metadata: {},
            isRead: false,
            createdAt: '2026-10-11T10:00:00Z',
          ),
        ]);
        fakeRepo.notificationsResult = Right(updatedPage);
        fakeRepo.unreadCountResult = const Right(2);

        final emittedStates = <NotificationState>[];
        final sub = cubit.stream.listen(emittedStates.add);

        await cubit.refreshNotificationsSilently();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(emittedStates.any((s) => s is NotificationLoading), isFalse);
        expect(emittedStates.length, 1);
        final latestState = emittedStates.single as NotificationSuccess;
        expect(latestState.unreadCount, 2);
        expect(latestState.page.notifications.length, 2);
      },
    );

    test(
      'preserves existing NotificationSuccess state when silent poll fails',
      () async {
        final initialPage = _buildPage(const [
          NotificationEntity(
            id: '1',
            type: 'task',
            title: 'Task 1',
            body: 'Body 1',
            metadata: {},
            isRead: false,
            createdAt: '2026-10-11T10:00:00Z',
          ),
        ]);
        fakeRepo.notificationsResult = Right(initialPage);
        fakeRepo.unreadCountResult = const Right(1);

        await cubit.loadNotifications();

        fakeRepo.notificationsResult = const Left(
          NetworkFailure('Offline during background poll'),
        );

        await cubit.refreshNotificationsSilently();

        expect(cubit.state, isA<NotificationSuccess>());
        final current = cubit.state as NotificationSuccess;
        expect(current.page.notifications.first.id, '1');
        expect(current.unreadCount, 1);
      },
    );

    test(
      'startPolling and stopPolling manage active timer and stop automatically when unauthenticated',
      () async {
        final page = _buildPage(const []);
        fakeRepo.notificationsResult = Right(page);
        fakeRepo.unreadCountResult = const Right(0);

        cubit.startPolling(interval: const Duration(milliseconds: 25));
        expect(cubit.isPolling, isTrue);

        await Future<void>.delayed(const Duration(milliseconds: 60));
        expect(fakeRepo.getNotificationsCallCount, greaterThanOrEqualTo(1));

        // Simulate user logging out while timer is active
        isUserAuthenticated = false;
        await Future<void>.delayed(const Duration(milliseconds: 40));
        expect(cubit.isPolling, isFalse);
      },
    );

    test(
      'markAsRead refreshes notifications silently without emitting NotificationLoading',
      () async {
        const unreadItem = NotificationEntity(
          id: '1',
          type: 'task',
          title: 'Task 1',
          body: 'Body 1',
          metadata: {},
          isRead: false,
          createdAt: '2026-10-11T10:00:00Z',
        );
        fakeRepo.notificationsResult = Right(_buildPage(const [unreadItem]));
        fakeRepo.unreadCountResult = const Right(1);

        await cubit.loadNotifications();

        const readItem = NotificationEntity(
          id: '1',
          type: 'task',
          title: 'Task 1',
          body: 'Body 1',
          metadata: {},
          isRead: true,
          createdAt: '2026-10-11T10:00:00Z',
        );
        fakeRepo.notificationsResult = Right(_buildPage(const [readItem]));
        fakeRepo.unreadCountResult = const Right(0);

        final emitted = <NotificationState>[];
        final sub = cubit.stream.listen(emitted.add);

        await cubit.markAsRead(unreadItem);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(fakeRepo.markReadCallCount, 1);
        expect(emitted.any((s) => s is NotificationLoading), isFalse);
        expect((cubit.state as NotificationSuccess).unreadCount, 0);
      },
    );
  });
}
