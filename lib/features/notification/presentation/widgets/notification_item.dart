import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({required this.notification, this.onTap, super.key});

  final NotificationEntity notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.space16),
        borderRadius: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              notification.isRead
                  ? Icons.notifications_none_rounded
                  : Icons.notifications_active_rounded,
              color: notification.isRead
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            const Gap(AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    notification.title?.isNotEmpty == true
                        ? notification.title!
                        : notification.type,
                    style: AppTextStyles.titleMedium,
                  ),
                  if (notification.body?.isNotEmpty == true) ...[
                    const Gap(AppSpacing.space4),
                    AppText(
                      notification.body!,
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.textSecondary,
                    ),
                  ],
                  const Gap(AppSpacing.space8),
                  AppText(
                    notification.createdAt,
                    style: AppTextStyles.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
