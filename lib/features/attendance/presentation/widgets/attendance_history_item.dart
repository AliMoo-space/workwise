import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/attendance/presentation/widgets/status_badge.dart';

class AttendanceHistoryItem extends StatelessWidget {
  const AttendanceHistoryItem({
    required this.date,
    required this.details,
    required this.status,
    required this.statusColor,
    super.key,
  });

  final String date;
  final String details;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      borderRadius: 20,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(date, style: AppTextStyles.titleMedium),
                const Gap(AppSpacing.space4),
                AppText(
                  details,
                  style: AppTextStyles.bodySmall,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          StatusBadge(label: status, color: statusColor),
        ],
      ),
    );
  }
}
