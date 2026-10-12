import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/empty_view/empty_view.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/extensions/context_extensions.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:workwise/features/notification/presentation/widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            final unreadCount = switch (state) {
              NotificationSuccess(:final unreadCount) => unreadCount,
              NotificationOperationFailure(:final unreadCount) => unreadCount,
              _ => 0,
            };
            return Text(
              unreadCount > 0
                  ? '${context.l10n.notifications} ($unreadCount)'
                  : context.l10n.notifications,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: context.read<NotificationCubit>().markAllAsRead,
            icon: const Icon(Icons.done_all_rounded),
            tooltip: context.l10n.markAllNotificationsAsRead,
          ),
          IconButton(
            onPressed: context.read<NotificationCubit>().clearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: context.l10n.clearAllNotifications,
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const _NotificationScreenSkeleton();
          }
          if (state is NotificationFailure) {
            return AppErrorState(
              message: state.message,
              onRetry: context.read<NotificationCubit>().loadNotifications,
            );
          }

          final page = switch (state) {
            NotificationSuccess(:final page) => page,
            NotificationOperationFailure(:final page) => page,
            _ => throw StateError('Unexpected notification state'),
          };
          if (page.notifications.isEmpty) {
            return EmptyView(
              icon: Icons.notifications_none_rounded,
              title: context.l10n.notifications,
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.space16.w),
            itemCount: page.notifications.length,
            separatorBuilder: (_, _) => const Gap(AppSpacing.space12),
            itemBuilder: (context, index) {
              final notification = page.notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: EdgeInsetsDirectional.only(
                    end: AppSpacing.space16.w,
                  ),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) =>
                    context.read<NotificationCubit>().delete(notification),
                child: NotificationItem(
                  notification: notification,
                  onTap: () => context.read<NotificationCubit>().markAsRead(
                    notification,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationScreenSkeleton extends StatelessWidget {
  const _NotificationScreenSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.space16.w),
        itemCount: 6,
        separatorBuilder: (_, _) => const Gap(AppSpacing.space12),
        itemBuilder: (_, _) => const AppCard(
          padding: EdgeInsets.all(AppSpacing.space16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.circle(size: 24),
              Gap(AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notification title'),
                    Gap(AppSpacing.space4),
                    Text('Notification body with placeholder content'),
                    Gap(AppSpacing.space8),
                    Text('Just now'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
