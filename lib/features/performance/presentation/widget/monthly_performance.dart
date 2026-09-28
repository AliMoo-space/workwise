import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_state.dart';

class MonthlyPerformance extends StatelessWidget {
  const MonthlyPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerformanceCubit, PerformanceState>(
      listener: (context, state) {
        if (state is PerformanceFailure) {
          AppSnackBar.error(context, message: state.message);
        }
      },
      child: BlocBuilder<PerformanceCubit, PerformanceState>(
        builder: (context, state) {
          // Loading
          if (state is PerformanceLoading) {
            return Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: Colors.white,
                highlightColor: Color(0xFFF1F1F1),
                duration: Duration(milliseconds: 1200),
              ),
              child: _buildPerformanceCard(
                context,
                periodName: 'This Month',
                changeLabel: '5% from last month',
                score: 87,
                isLoading: true,
              ),
            );
          }
          // Success
          if (state is PerformanceSuccess) {
            final performance = state.performance;
            return _buildPerformanceCard(
              context,
              periodName: performance.periodName,
              changeLabel: performance.changeLabel,
              score: performance.score,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context, {
    required String periodName,
    required String changeLabel,
    required double score,
    bool isLoading = false,
  }) {
    return AppCard(
      height: 180.h,
      width: double.infinity.w,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: Colors.transparent, width: 0),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =========================
          // Performance Info
          // =========================
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                periodName,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),

              Gap(AppSpacing.space4.h),

              AppText(
                context.l10n.yourPerformance,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),

              Gap(AppSpacing.space4.h),

              AppText(
                changeLabel,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),

          // =========================
          // Performance Circle
          // =========================
          CircularPercentIndicator(
            radius: 50.0.r,
            lineWidth: 8.0.w,
            percent: score / 100,
            animation: !isLoading,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: isLoading
                ? Colors.white.withValues(alpha: 0.35)
                : Theme.of(context).colorScheme.outline,
            progressColor: isLoading
                ? Colors.white
                : Theme.of(context).colorScheme.secondary,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  '${score.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Gap(AppSpacing.space4.h),

                AppText(
                  context.l10n.overall,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
