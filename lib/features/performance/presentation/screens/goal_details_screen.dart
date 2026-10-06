import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
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
      child: _GoalDetailsView(goalId: goalId),
    );
  }
}

class _GoalDetailsView extends StatelessWidget {
  const _GoalDetailsView({required this.goalId});

  final int goalId;

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
            // Loading

            if (state is GoalDetailsLoading) {
              return Skeletonizer(
                enabled: true,
                effect: const ShimmerEffect(
                  baseColor: Color(0xFFF7F9FB),
                  highlightColor: Color(0xFFFFFFFF),
                  duration: Duration(milliseconds: 1400),
                ),
                child: const GoalDetailsCard(goal: null),
              );
            }

            // Success

            if (state is GoalDetailsSuccess) {
              return GoalDetailsCard(goal: state.goal);
            }

            // Failure

            if (state is GoalDetailsFailure) {
              return AppErrorState(
                message: state.message,
                onRetry: () {
                  context.read<GoalsCubit>().getGoalDetailsData(goalId);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class GoalDetailsCard extends StatelessWidget {
  const GoalDetailsCard({super.key, required this.goal});

  final GoalDetailsEntity? goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = goal == null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      child: Column(
        children: [
          // Goal information card
          AppCard(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: theme.colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius12.r,
                        ),
                      ),
                      child: Icon(
                        Icons.flag_outlined,
                        size: 22.sp,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    Gap(AppSpacing.space12.w),

                    Expanded(
                      child: isLoading
                          ? Bone(
                              height: 24.h,
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius8.r,
                              ),
                            )
                          : AppText(
                              goal!.title,
                              style: theme.textTheme.headlineSmall,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                    ),

                    Gap(AppSpacing.space8.w),

                    isLoading
                        ? Bone(
                            width: 75.w,
                            height: 32.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius32.r,
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.space12.w,
                              vertical: AppSpacing.space8.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant,
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
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                Gap(AppSpacing.space8.w),

                                AppText(
                                  goal!.status,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),

                Gap(AppSpacing.space16.h),

                isLoading
                    ? Column(
                        children: [
                          Bone(
                            width: double.infinity,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius4.r,
                            ),
                          ),
                          Gap(AppSpacing.space8.h),
                          Bone(
                            width: 220.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius4.r,
                            ),
                          ),
                        ],
                      )
                    : AppText(
                        goal!.description,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.start,
                      ),
              ],
            ),
          ),

          Gap(AppSpacing.space16.h),

          // Goal dates card
          AppCard(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.space16.r),
            backgroundColor: theme.colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: isLoading
                ? Column(
                    children: [
                      _buildLoadingRow(context),

                      Gap(AppSpacing.space16.h),

                      Bone(width: double.infinity, height: 1.h),

                      Gap(AppSpacing.space16.h),

                      _buildLoadingRow(context),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: .10,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius12.r,
                              ),
                            ),
                            child: Icon(
                              Icons.event_outlined,
                              size: 20.sp,
                              color: theme.colorScheme.primary,
                            ),
                          ),

                          Gap(AppSpacing.space12.w),

                          Expanded(
                            child: AppText(
                              context.l10n.targetDate,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),

                          AppText(
                            goal!.targetDate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.space16.h,
                        ),
                        child: Divider(
                          color: theme.colorScheme.outlineVariant,
                          height: 1,
                        ),
                      ),

                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: .10,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius12.r,
                              ),
                            ),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              size: 20.sp,
                              color: theme.colorScheme.primary,
                            ),
                          ),

                          Gap(AppSpacing.space12.w),

                          Expanded(
                            child: AppText(
                              context.l10n.createdAt,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),

                          AppText(
                            goal!.createdAt,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildLoadingRow(BuildContext context) {
    return Row(
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
            borderRadius: BorderRadius.circular(AppRadius.radius4.r),
          ),
        ),

        Gap(AppSpacing.space12.w),

        Bone(
          width: 95.w,
          height: 18.h,
          borderRadius: BorderRadius.circular(AppRadius.radius4.r),
        ),
      ],
    );
  }
}
