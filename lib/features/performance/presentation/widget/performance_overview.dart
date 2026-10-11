import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key, required this.performance});

  final PerformanceEntity performance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCard(
          context,
          value: '${performance.tasksRate.toStringAsFixed(0)}%',
          title: context.l10n.tasks,
        ),
        _buildCard(
          context,
          value: '${performance.qualityRate.toStringAsFixed(0)}%',
          title: context.l10n.quality,
        ),
        _buildCard(
          context,
          value: '${performance.attendanceRate.toStringAsFixed(0)}%',
          title: context.l10n.attendance,
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String value,
    required String title,
  }) {
    return AppCard(
      height: 100.h,
      width: 110.w,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
      borderRadius: AppRadius.radius16.r,
      boxShadow: const [],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            value,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.start,
          ),
          AppText(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
