import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'package:workwise/features/performance/presentation/cubit/performance/performance_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_state.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceCubit, PerformanceState>(
      builder: (context, state) {
        // Loading
        if (state is PerformanceLoading) {
          return Skeletonizer(
            enabled: true,
            effect: const ShimmerEffect(
              baseColor: Color(0xFFC9D4DF),
              highlightColor: Color(0xFFF8FAFC),
              duration: Duration(milliseconds: 1200),
            ),
            child: _buildOverview(
              context,
              tasks: '92%',
              quality: '88%',
              attendance: '95%',
            ),
          );
        }
        // Success
        if (state is PerformanceSuccess) {
          final performance = state.performance;
          return _buildOverview(
            context,
            tasks: '${performance.tasksRate.toStringAsFixed(0)}%',
            quality: '${performance.qualityRate.toStringAsFixed(0)}%',
            attendance: '${performance.attendanceRate.toStringAsFixed(0)}%',
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOverview(
    BuildContext context, {
    required String tasks,
    required String quality,
    required String attendance,
  }) {
    Widget card({required String value, required String title}) {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        card(value: tasks, title: context.l10n.tasks),
        card(value: quality, title: context.l10n.quality),
        card(value: attendance, title: context.l10n.attendance),
      ],
    );
  }
}
