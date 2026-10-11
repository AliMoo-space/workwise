part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

final class NotificationSuccess extends NotificationState {
  const NotificationSuccess(this.page, {this.unreadCount = 0});

  final NotificationPageEntity page;
  final int unreadCount;

  @override
  List<Object?> get props => [page, unreadCount];
}

final class NotificationOperationFailure extends NotificationState {
  const NotificationOperationFailure(this.page, this.message, this.unreadCount);

  final NotificationPageEntity page;
  final String message;
  final int unreadCount;

  @override
  List<Object?> get props => [page, message, unreadCount];
}

final class NotificationFailure extends NotificationState {
  const NotificationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
