import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/features/performance/presentation/widget/at_a_glance_header.dart';
import 'package:workwise/features/performance/presentation/widget/home_greeting.dart';
import 'package:workwise/features/performance/presentation/widget/monthly_performance.dart';
import 'package:workwise/features/performance/presentation/widget/performance_overview.dart';
import 'package:workwise/features/performance/presentation/widget/performance_trend_chart.dart';
import 'package:workwise/features/performance/presentation/widget/performance_trend_header.dart';
import 'package:workwise/features/performance/presentation/widget/personal_goals_list.dart';
import 'package:workwise/features/performance/presentation/widget/personal_goals_title.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HomeGreeting(),

                const Gap(AppSpacing.space16),

                const MonthlyPerformance(),

                const Gap(AppSpacing.space8),

                const AtAGlanceHeader(),

                const Gap(AppSpacing.space8),

                const PerformanceOverview(),

                const Gap(AppSpacing.space8),

                const PerformanceTrendHeader(),

                const Gap(AppSpacing.space8),

                const PerformanceTrendChart(),

                const Gap(AppSpacing.space8),

                const PersonalGoalsTitle(),

                const Gap(AppSpacing.space8),

                const PersonalGoalsList(),

                const Gap(AppSpacing.space8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
