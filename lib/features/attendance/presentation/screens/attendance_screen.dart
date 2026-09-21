import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/attendance/presentation/widgets/attendance_history_item.dart';
import 'package:workwise/features/attendance/presentation/widgets/location_status_card.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(
          context.l10n.attendance,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space24.h,
        ),
        children: [
          // AppText(context.l10n.attendance, style: AppTextStyles.headlineLarge),
          // const Gap(AppSpacing.space4),
          // AppText(
          //   context.l10n.attendanceDescription,
          //   style: AppTextStyles.bodyMedium,
          //   color: AppColors.textSecondary,
          // ),
          // const Gap(AppSpacing.space20),
          const LocationStatusCard(),
          const Gap(AppSpacing.space20),
          AppButton(
            text: context.l10n.checkOut,
            onPressed: () {},
            leading: const Icon(Icons.logout, color: AppColors.onPrimary),
          ),
          const Gap(AppSpacing.space20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  context.l10n.history,
                  style: AppTextStyles.headlineSmall,
                ),
              ),
              const Gap(AppSpacing.space8),
              Flexible(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  label: Text(context.l10n.june2026),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.space12),
          ...[
            (
              date: context.l10n.attendanceDate1,
              details: context.l10n.attendanceDetails1,
              status: context.l10n.present,
              statusColor: AppColors.success,
            ),
            (
              date: context.l10n.attendanceDate2,
              details: context.l10n.attendanceDetails2,
              status: context.l10n.late,
              statusColor: AppColors.warning,
            ),
            (
              date: context.l10n.attendanceDate3,
              details: context.l10n.attendanceDetails3,
              status: context.l10n.present,
              statusColor: AppColors.success,
            ),
          ].expand(
            (record) => [
              const Gap(AppSpacing.space12),
              AttendanceHistoryItem(
                date: record.date,
                details: record.details,
                status: record.status,
                statusColor: record.statusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
