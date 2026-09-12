import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
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
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HomeGreeting(),

                Gap(15.h),

                const MonthlyPerformance(),

                Gap(10.h),

                const AtAGlanceHeader(),

                Gap(10.h),

                const PerformanceOverview(),

                Gap(10.h),

                const PerformanceTrendHeader(),

                Gap(10.h),

                const PerformanceTrendChart(),

                Gap(10.h),

                const PersonalGoalsTitle(),

                Gap(10.h),

                const PersonalGoalsList(),

                Gap(10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
