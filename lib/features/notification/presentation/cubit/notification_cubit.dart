import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';
import 'package:workwise/features/notification/domain/usecases/get_notifications.dart';
import 'package:workwise/features/notification/domain/usecases/notification_actions.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.getNotifications,
    required this.getUnreadNotificationsCount,
    required this.markNotificationAsRead,
    required this.markAllNotificationsAsRead,
    required this.clearAllNotifications,
    required this.deleteNotification,
  }) : super(const NotificationInitial());

  final GetNotifications getNotifications;
  final GetUnreadNotificationsCount getUnreadNotificationsCount;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;
  final ClearAllNotifications clearAllNotifications;
  final DeleteNotification deleteNotification;

  Future<void> loadNotifications({int? perPage}) async {
    emit(const NotificationLoading());
    final result = await getNotifications(perPage: perPage);
    if (result.isLeft()) {
      emit(
        NotificationFailure(
          result
              .swap()
              .getOrElse(() => throw StateError('Missing notification failure'))
              .message,
        ),
      );
      return;
    }

    final page = result.getOrElse(
      () => throw StateError('Missing notification page'),
    );
    final unreadResult = await getUnreadNotificationsCount();
    unreadResult.fold(
      (failure) => emit(NotificationOperationFailure(page, failure.message, 0)),
      (unreadCount) =>
          emit(NotificationSuccess(page, unreadCount: unreadCount)),
    );
  }

  Future<void> markAsRead(NotificationEntity notification) async {
    if (notification.isRead || state is! NotificationSuccess) return;
    final result = await markNotificationAsRead(notification.id);
    result.fold(
      (failure) => _emitOperationFailure(failure.message),
      (_) => loadNotifications(),
    );
  }

  Future<void> markAllAsRead() async {
    if (state is! NotificationSuccess) return;
    final result = await markAllNotificationsAsRead();
    result.fold(
      (failure) => _emitOperationFailure(failure.message),
      (_) => loadNotifications(),
    );
  }

  Future<void> clearAll() async {
    final result = await clearAllNotifications();
    result.fold(
      (failure) => _emitOperationFailure(failure.message),
      (_) => loadNotifications(),
    );
  }

  Future<void> delete(NotificationEntity notification) async {
    final result = await deleteNotification(notification.id);
    result.fold(
      (failure) => _emitOperationFailure(failure.message),
      (_) => loadNotifications(),
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
}
