import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_state.dart';

class PersonalGoalsList extends StatelessWidget {
  const PersonalGoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalsCubit, GoalsState>(
      listener: (context, state) {
        if (state is GoalsFailure) {
          AppSnackBar.error(context, message: state.message);
        }
      },
      child: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state is GoalsLoading) {
            return Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: Color(0xFFC9D4DF),
                highlightColor: Color(0xFFF8FAFC),
                duration: Duration(milliseconds: 1200),
              ),
              child: _buildGoalsList(context, isLoading: true),
            );
          }
          if (state is GoalsSuccess) {
            final goals = state.goals;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == goals.length - 1
                        ? 0
                        : AppSpacing.space12.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.push('${AppRoutes.goalDetailsScreen}/${goal.id}');
                    },
                    child: AppCard(
                      height: 120.h,
                      width: double.infinity.w,
                      padding: EdgeInsets.all(AppSpacing.space8.r),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      goal.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                    AppText(
                                      goal.description,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                    Gap(AppSpacing.space8),
                                    AppText(
                                      '${context.l10n.target} ${goal.targetDate}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              AppCard(
                                width: 100.w,
                                height: 35.h,
                                padding: EdgeInsets.zero,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                                borderRadius: AppRadius.radius32.r,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                                boxShadow: const [],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 8.h,
                                      width: 8.w,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.radius16.r,
                                        ),
                                      ),
                                    ),
                                    Gap(AppSpacing.space8.w),
                                    AppText(
                                      goal.status,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(AppSpacing.space16.h),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: goal.progressPercentage / 100,
                                  backgroundColor: AppColors.border,
                                  minHeight: 8.h,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.radius8.r,
                                  ),
                                ),
                              ),
                              Gap(AppSpacing.space8.w),
                              AppText(
                                '${goal.progressPercentage}%',
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Widget _buildGoalsList(
  BuildContext context, {
  List<Goal>? goals,
  bool isLoading = false,
}) {
  final itemsCount = isLoading ? 2 : goals!.length;

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemsCount,
    itemBuilder: (context, index) {
      final goal = isLoading ? null : goals![index];

      return Padding(
        padding: EdgeInsets.only(
          bottom: index == itemsCount - 1 ? 0 : AppSpacing.space12.h,
        ),
        child: AppCard(
          height: 120.h,
          width: double.infinity.w,
          padding: EdgeInsets.all(AppSpacing.space8.r),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          isLoading
                              ? 'Complete Advanced SQL certification'
                              : goal!.title,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                        AppText(
                          isLoading
                              ? '${context.l10n.target} 30/11/2026'
                              : '${context.l10n.target} ${goal!.targetDate}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AppCard(
                    width: 100.w,
                    height: 35.h,
                    padding: EdgeInsets.zero,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant,
                    borderRadius: AppRadius.radius32.r,
                    border: Border.all(color: Colors.transparent, width: 0),
                    boxShadow: const [],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) ...[
                          Bone(
                            width: 8.w,
                            height: 8.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius16.r,
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          Bone(
                            width: 45.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius4.r,
                            ),
                          ),
                        ] else ...[
                          Container(
                            height: 8.h,
                            width: 8.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius16.r,
                              ),
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          AppText(
                            goal!.status,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              Gap(AppSpacing.space16.h),
              Row(
                children: [
                  Expanded(
                    child: isLoading
                        ? Bone(
                            height: 8.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius8.r,
                            ),
                          )
                        : LinearProgressIndicator(
                            value: goal!.progressPercentage / 100,
                            backgroundColor: AppColors.border,
                            minHeight: 8.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius8.r,
                            ),
                          ),
                  ),
                  Gap(AppSpacing.space8.w),
                  isLoading
                      ? Bone(
                          width: 35.w,
                          height: 16.h,
                          borderRadius: BorderRadius.circular(
                            AppRadius.radius4.r,
                          ),
                        )
                      : AppText(
                          '${goal!.progressPercentage}%',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.start,
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
