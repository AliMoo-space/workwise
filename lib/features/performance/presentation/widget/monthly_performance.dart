// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

class MonthlyPerformance extends StatelessWidget {
  const MonthlyPerformance({super.key, required this.performance});

  final PerformanceEntity performance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      height: 180.h,
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: theme.colorScheme.outlineVariant,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.w),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                performance.periodName,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Gap(AppSpacing.space4.h),
              AppText(
                context.l10n.yourPerformance,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              Gap(AppSpacing.space4.h),
              AppText(
                performance.changeLabel,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          CircularPercentIndicator(
            radius: 50.0.r,
            lineWidth: 8.0.w,
            percent: (performance.score / 100).clamp(0.0, 1.0),
            animation: true,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: theme.colorScheme.surface,
            progressColor: theme.colorScheme.secondary,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  '${performance.score.toStringAsFixed(0)}%',
                  style: theme.textTheme.headlineMedium,
                ),
                Gap(AppSpacing.space4.h),
                AppText(
                  context.l10n.overall,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
