import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_state.dart';
import 'package:workwise/features/performance/presentation/widget/goal_card.dart';

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
          // Goals Error
          if (state is GoalsFailure) {
            AppSnackBar.error(context, message: state.message);
          }
        },
        child: BlocBuilder<GoalsCubit, GoalsState>(
          builder: (context, state) {
            // Loading

            if (state is GoalsLoading) {
              return Skeletonizer(
                enabled: true,
                effect: const ShimmerEffect(
                  baseColor: Color(0xFFF7F9FB),
                  highlightColor: Color(0xFFFFFFFF),
                  duration: Duration(milliseconds: 1400),
                ),
                child: _buildGoalsList(context, isLoading: true),
              );
            }

            // Success

            if (state is GoalsSuccess) {
              final goals = state.goals;

              if (goals.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.space24.r),
                    child: Text(
                      context.l10n.noGoalsFound,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return _buildGoalsList(context, goals: goals);
            }

            // Failure

            if (state is GoalsFailure) {
              return AppErrorState(
                message: state.message,
                onRetry: () {
                  context.read<GoalsCubit>().getGoalsData();
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildGoalsList(
    BuildContext context, {
    List<Goal>? goals,
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
          child: GoalCard(
            goal: goal,
            isLoading: isLoading,
            onTap: isLoading
                ? null
                : () {
                    context.push('${AppRoutes.goalDetailsScreen}/${goal!.id}');
                  },
          ),
        );
      },
    );
  }
}
