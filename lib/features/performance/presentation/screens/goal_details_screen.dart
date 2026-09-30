import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal_details_entity.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_state.dart';

class GoalDetailsScreen extends StatelessWidget {
  const GoalDetailsScreen({super.key, required this.goalId});
  final int goalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GoalsCubit>()..getGoalDetailsData(goalId),
      child: const _GoalDetailsView(),
    );
  }
}

class _GoalDetailsView extends StatelessWidget {
  const _GoalDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(
          context.l10n.goalDetails,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocListener<GoalsCubit, GoalsState>(
        listener: (context, state) {
          if (state is GoalDetailsFailure) {
            AppSnackBar.error(context, message: state.message);
          }
        },
        child: BlocBuilder<GoalsCubit, GoalsState>(
          builder: (context, state) {
            if (state is GoalDetailsLoading) {
              return Skeletonizer(
                enabled: true,
                effect: const ShimmerEffect(
                  baseColor: Color(0xFFC9D4DF),
                  highlightColor: Color(0xFFF8FAFC),
                  duration: Duration(milliseconds: 1200),
                ),
                child: _buildGoalDetailsSkeleton(context),
              );
            }

            if (state is GoalDetailsSuccess) {
              return _buildGoalDetails(context, state.goal);
            }

            if (state is GoalDetailsFailure) {
              return Center(
                child: AppText(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildGoalDetailsSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            width: double.infinity,
            height: 155.h,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Bone(
                        width: double.infinity,
                        height: 24.h,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius8.r,
                        ),
                      ),
                    ),
                    Gap(AppSpacing.space8.w),
                    Bone(
                      width: 75.w,
                      height: 32.h,
                      borderRadius: BorderRadius.circular(AppRadius.radius32.r),
                    ),
                  ],
                ),
                Gap(AppSpacing.space16.h),
                Bone(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
                Gap(AppSpacing.space8.h),
                Bone(
                  width: 220.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
              ],
            ),
          ),

          Gap(AppSpacing.space16.h),

          AppCard(
            width: double.infinity,
            height: 125.h,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 100.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
                Gap(AppSpacing.space16.h),
                Bone(
                  width: double.infinity,
                  height: 8.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius8.r),
                ),
                Gap(AppSpacing.space12.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Bone(
                    width: 45.w,
                    height: 18.h,
                    borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                  ),
                ),
              ],
            ),
          ),

          Gap(AppSpacing.space16.h),

          Row(
            children: [
              Expanded(
                child: Bone(
                  height: 95.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                ),
              ),
              Gap(AppSpacing.space12.w),
              Expanded(
                child: Bone(
                  height: 95.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          AppCard(
            width: double.infinity,
            height: 175.h,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              children: [
                Row(
                  children: [
                    Bone(
                      width: 40.w,
                      height: 40.w,
                      borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                    ),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: Bone(
                        height: 18.h,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius4.r,
                        ),
                      ),
                    ),
                    Gap(AppSpacing.space12.w),
                    Bone(
                      width: 95.w,
                      height: 18.h,
                      borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                    ),
                  ],
                ),
                Gap(AppSpacing.space16.h),
                Bone(width: double.infinity, height: 1.h),
                Gap(AppSpacing.space16.h),
                Row(
                  children: [
                    Bone(
                      width: 40.w,
                      height: 40.w,
                      borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                    ),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: Bone(
                        height: 18.h,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius4.r,
                        ),
                      ),
                    ),
                    Gap(AppSpacing.space12.w),
                    Bone(
                      width: 95.w,
                      height: 18.h,
                      borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalDetails(BuildContext context, GoalDetailsEntity goal) {
    final progress = (goal.progressPercentage / 100).clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        goal.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Gap(AppSpacing.space8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space12.w,
                        vertical: AppSpacing.space8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius32.r,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          AppText(
                            goal.status,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.space12.h),
                AppText(
                  goal.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),

          Gap(AppSpacing.space16.h),

          AppCard(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.progress,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(AppSpacing.space16.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border,
                        minHeight: 8.h,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius8.r,
                        ),
                      ),
                    ),
                    Gap(AppSpacing.space12.w),
                    AppText(
                      '${goal.progressPercentage}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Gap(AppSpacing.space16.h),

          Row(
            children: [
              Expanded(
                child: AppCard(
                  height: 95.h,
                  padding: EdgeInsets.all(AppSpacing.space12.r),
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  borderRadius: AppRadius.radius20.r,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: .7.w,
                  ),
                  boxShadow: const [],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        context.l10n.currentValue,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Gap(AppSpacing.space4.h),
                      AppText(
                        '${goal.currentValue}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(AppSpacing.space12.w),
              Expanded(
                child: AppCard(
                  height: 95.h,
                  padding: EdgeInsets.all(AppSpacing.space12.r),
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  borderRadius: AppRadius.radius20.r,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: .7.w,
                  ),
                  boxShadow: const [],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        context.l10n.targetValue,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Gap(AppSpacing.space4.h),
                      AppText(
                        '${goal.targetValue}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Gap(AppSpacing.space16.h),

          AppCard(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 20.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.targetDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    AppText(
                      goal.targetDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Gap(AppSpacing.space16.h),
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                Gap(AppSpacing.space16.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Gap(AppSpacing.space12.w),
                    Expanded(
                      child: AppText(
                        context.l10n.createdAt,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    AppText(
                      goal.createdAt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
