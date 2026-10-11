import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/goals/goals_state.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_state.dart';
import 'package:workwise/features/performance/presentation/widget/at_a_glance_header.dart';
import 'package:workwise/features/performance/presentation/widget/monthly_performance.dart';
import 'package:workwise/features/performance/presentation/widget/performance_loading_view.dart';
import 'package:workwise/features/performance/presentation/widget/performance_overview.dart';
import 'package:workwise/features/performance/presentation/widget/performance_trend_chart.dart';
import 'package:workwise/features/performance/presentation/widget/performance_trend_header.dart';
import 'package:workwise/features/performance/presentation/widget/personal_goals_list.dart';
import 'package:workwise/features/performance/presentation/widget/personal_goals_title.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PerformanceCubit>()..getPerformance()),
        BlocProvider(create: (_) => sl<GoalsCubit>()..getGoalsData()),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppAppBar(
          title: Text(
            context.l10n.performance,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              // Performance Error
              BlocListener<PerformanceCubit, PerformanceState>(
                listener: (context, state) {
                  if (state is PerformanceFailure) {
                    AppSnackBar.error(context, message: state.message);
                  }
                },
              ),

              // Goals Error
              BlocListener<GoalsCubit, GoalsState>(
                listener: (context, state) {
                  if (state is GoalsFailure) {
                    AppSnackBar.error(context, message: state.message);
                  }
                },
              ),
            ],
            child: BlocBuilder<PerformanceCubit, PerformanceState>(
              builder: (context, performanceState) {
                return BlocBuilder<GoalsCubit, GoalsState>(
                  builder: (context, goalsState) {
                    // Performance Failure

                    if (performanceState is PerformanceFailure) {
                      return AppErrorState(
                        message: performanceState.message,
                        onRetry: () {
                          context.read<PerformanceCubit>().getPerformance();

                          context.read<GoalsCubit>().getGoalsData();
                        },
                      );
                    }

                    // Goals Failure

                    if (goalsState is GoalsFailure) {
                      return AppErrorState(
                        message: goalsState.message,
                        onRetry: () {
                          context.read<PerformanceCubit>().getPerformance();

                          context.read<GoalsCubit>().getGoalsData();
                        },
                      );
                    }

                    // Loading

                    final isLoading =
                        performanceState is PerformanceLoading ||
                        goalsState is GoalsLoading;

                    if (isLoading) {
                      return PerformanceLoadingView.build(context);
                    }

                    // Success

                    if (performanceState is PerformanceSuccess &&
                        goalsState is GoalsSuccess) {
                      final performance = performanceState.performance;

                      final goals = goalsState.goals;

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.space16),
                          child: Column(
                            children: [
                              MonthlyPerformance(performance: performance),

                              const Gap(AppSpacing.space8),

                              const AtAGlanceHeader(),

                              const Gap(AppSpacing.space8),

                              PerformanceOverview(performance: performance),

                              const Gap(AppSpacing.space8),

                              const PerformanceTrendHeader(),

                              const Gap(AppSpacing.space8),

                              PerformanceTrendChart(
                                performanceTrend: performance.performanceTrend,
                              ),

                              const Gap(AppSpacing.space8),

                              PersonalGoalsTitle(hasGoals: goals.isNotEmpty),

                              const Gap(AppSpacing.space8),

                              PersonalGoalsList(goals: goals.take(2).toList()),

                              const Gap(AppSpacing.space8),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
