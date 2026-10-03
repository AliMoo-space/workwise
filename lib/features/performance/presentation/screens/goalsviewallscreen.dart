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
import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_state.dart';

class GoalsViewAllScreen extends StatelessWidget {
  const GoalsViewAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GoalsCubit>()..getGoalsData(),
      child: const _GoalsViewAllBody(),
    );
  }
}

class _GoalsViewAllBody extends StatelessWidget {
  const _GoalsViewAllBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(
          context.l10n.goals,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocListener<GoalsCubit, GoalsState>(
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

              if (goals.isEmpty) {
                return Center(
                  child: AppText(
                    context.l10n.noGoalsFound,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return _buildGoalsList(context, goals: goals);
            }

            if (state is GoalsFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.space24.r),
                  child: AppText(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

Widget _buildGoalsList(
  BuildContext context, {
  List<dynamic>? goals,
  bool isLoading = false,
}) {
  final itemsCount = isLoading ? 2 : goals!.length;

  return ListView.builder(
    padding: EdgeInsets.all(AppSpacing.space16.r),
    itemCount: itemsCount,
    itemBuilder: (context, index) {
      final goal = isLoading ? null : goals![index];

      return Padding(
        padding: EdgeInsets.only(
          bottom: index == itemsCount - 1 ? 0 : AppSpacing.space12.h,
        ),
        child: AppCard(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          isLoading
                              ? 'Complete Advanced SQL certification'
                              : goal.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),

                        Gap(AppSpacing.space4.h),

                        AppText(
                          isLoading
                              ? 'Improve technical skills'
                              : goal.description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  Gap(AppSpacing.space12.w),

                  AppCard(
                    width: 92.w,
                    height: 32.h,
                    padding: EdgeInsets.zero,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: .55),
                    borderRadius: AppRadius.radius32.r,
                    border: Border.all(color: Colors.transparent),
                    boxShadow: const [],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) ...[
                          Bone(
                            width: 7.w,
                            height: 7.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius16.r,
                            ),
                          ),
                          Gap(AppSpacing.space4.w),
                          Bone(
                            width: 42.w,
                            height: 13.h,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius4.r,
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(AppSpacing.space4.w),
                          Flexible(
                            child: AppText(
                              goal.status,
                              style: Theme.of(context).textTheme.labelMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              Gap(AppSpacing.space20.h),

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
                            value: (goal.progressPercentage / 100).clamp(
                              0.0,
                              1.0,
                            ),
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
                          width: 38.w,
                          height: 16.h,
                          borderRadius: BorderRadius.circular(
                            AppRadius.radius4.r,
                          ),
                        )
                      : AppText(
                          '${goal.progressPercentage}%',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.end,
                        ),
                ],
              ),

              Gap(AppSpacing.space12.h),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),

                  Gap(AppSpacing.space4.w),

                  AppText(
                    isLoading
                        ? '${context.l10n.target} 30/11/2026'
                        : '${context.l10n.target} ${goal.targetDate}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
