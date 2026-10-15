import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';
import 'package:workwise/features/notification/domain/usecases/get_notifications.dart';
import 'package:workwise/features/notification/domain/usecases/notification_actions.dart';

part 'notification_state.dart';

typedef NotificationAuthCheck = Future<bool> Function();

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.getNotifications,
    required this.getUnreadNotificationsCount,
    required this.markNotificationAsRead,
    required this.markAllNotificationsAsRead,
    required this.clearAllNotifications,
    required this.deleteNotification,
    Stream<void>? foregroundNotificationStream,
    NotificationAuthCheck? isAuthenticated,
  }) : _isAuthenticated = isAuthenticated ?? (() async => true),
       super(const NotificationInitial()) {
    if (foregroundNotificationStream != null) {
      _foregroundNotificationSubscription = foregroundNotificationStream.listen(
        (_) => refreshNotificationsSilently(),
      );
    }
  }

  static const Duration defaultPollingInterval = Duration(seconds: 30);

  final GetNotifications getNotifications;
  final GetUnreadNotificationsCount getUnreadNotificationsCount;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;
  final ClearAllNotifications clearAllNotifications;
  final DeleteNotification deleteNotification;
  final NotificationAuthCheck _isAuthenticated;

  Timer? _pollingTimer;
  StreamSubscription<void>? _foregroundNotificationSubscription;
  bool _isLoading = false;
  bool _isRefreshing = false;

  bool get isPolling => _pollingTimer?.isActive ?? false;

  Future<void> loadNotifications({int? perPage}) async {
    if (_isLoading || isClosed) return;
    _isLoading = true;
    emit(const NotificationLoading());
    try {
      final result = await getNotifications(perPage: perPage);
      if (isClosed) return;
      if (result.isLeft()) {
        emit(
          NotificationFailure(
            result
                .swap()
                .getOrElse(
                  () => throw StateError('Missing notification failure'),
                )
                .message,
          ),
        );
        return;
      }

      final page = result.getOrElse(
        () => throw StateError('Missing notification page'),
      );
      final unreadResult = await getUnreadNotificationsCount();
      if (isClosed) return;
      unreadResult.fold(
        (failure) =>
            emit(NotificationOperationFailure(page, failure.message, 0)),
        (unreadCount) =>
            emit(NotificationSuccess(page, unreadCount: unreadCount)),
      );
    } finally {
      _isLoading = false;
    }
  }

  /// Refreshes notifications in the foreground without emitting
  /// [NotificationLoading], preserving existing list items and scroll position.
  Future<void> refreshNotificationsSilently({int? perPage}) async {
    if (_isRefreshing ||
        _isLoading ||
        isClosed ||
        state is NotificationLoading) {
      return;
    }

    _isRefreshing = true;
    try {
      final authenticated = await _isAuthenticated();
      if (!authenticated || isClosed) {
        stopPolling();
        return;
      }

      final result = await getNotifications(perPage: perPage);
      if (isClosed) return;

      await result.fold(
        (_) async {
          // Preserve existing notification state on background poll failure.
        },
        (page) async {
          final unreadResult = await getUnreadNotificationsCount();
          if (isClosed) return;

          final previousUnreadCount = switch (state) {
            NotificationSuccess(:final unreadCount) => unreadCount,
            NotificationOperationFailure(:final unreadCount) => unreadCount,
            _ => page.notifications.where((item) => !item.isRead).length,
          };

          unreadResult.fold(
            (_) => emit(
              NotificationSuccess(page, unreadCount: previousUnreadCount),
            ),
            (unreadCount) =>
                emit(NotificationSuccess(page, unreadCount: unreadCount)),
          );
        },
      );
    } finally {
      _isRefreshing = false;
    }
  }

  void startPolling({
    Duration interval = defaultPollingInterval,
    int? perPage,
  }) {
    if (isClosed) return;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) {
      refreshNotificationsSilently(perPage: perPage);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> markAsRead(NotificationEntity notification) async {
    if (notification.isRead || state is! NotificationSuccess) return;
    final result = await markNotificationAsRead(notification.id);
    await result.fold(
      (failure) async => _emitOperationFailure(failure.message),
      (_) => refreshNotificationsSilently(),
    );
  }

  Future<void> markAllAsRead() async {
    if (state is! NotificationSuccess) return;
    final result = await markAllNotificationsAsRead();
    await result.fold(
      (failure) async => _emitOperationFailure(failure.message),
      (_) => refreshNotificationsSilently(),
    );
  }

  Future<void> clearAll() async {
    final result = await clearAllNotifications();
    await result.fold(
      (failure) async => _emitOperationFailure(failure.message),
      (_) => refreshNotificationsSilently(),
    );
  }

  Future<void> delete(NotificationEntity notification) async {
    final result = await deleteNotification(notification.id);
    await result.fold(
      (failure) async => _emitOperationFailure(failure.message),
      (_) => refreshNotificationsSilently(),
    );
  }

  void _emitOperationFailure(String message) {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      emit(
        NotificationOperationFailure(
          currentState.page,
          message,
          currentState.unreadCount,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    stopPolling();
    await _foregroundNotificationSubscription?.cancel();
    return super.close();
  }
}
