import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_state.dart';

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceCubit, PerformanceState>(
      builder: (context, state) {
        // Loading
        if (state is PerformanceLoading) {
          return Skeletonizer(
            enabled: true,
            effect: const ShimmerEffect(duration: Duration(milliseconds: 1200)),
            child: _buildChart(context, [
              PerformanceTrendEntity(month: 'Aug', overallScore: 20.5),
              PerformanceTrendEntity(month: 'Sep', overallScore: 50),
              PerformanceTrendEntity(month: 'Oct', overallScore: 70),
              PerformanceTrendEntity(month: 'Nov', overallScore: 92),
            ], isLoading: true),
          );
        }

        // Success
        if (state is PerformanceSuccess) {
          final performanceTrend = state.performance.performanceTrend;

          if (performanceTrend.isEmpty) {
            return const SizedBox.shrink();
          }

          return _buildChart(context, performanceTrend, isLoading: false);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<PerformanceTrendEntity> performanceTrend, {
    required bool isLoading,
  }) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      height: 180.h,
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius16.r,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 1,
      ),
      boxShadow: const [],
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= performanceTrend.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: AppSpacing.space8.h),
                    child: AppText(
                      performanceTrend[index].month,
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,

              // لون الخط أثناء التحميل
              color: isLoading
                  ? const Color(0xFFC9D4DF)
                  : Theme.of(context).colorScheme.secondary,

              barWidth: 3.w,
              isStrokeCapRound: true,

              dotData: const FlDotData(show: false),

              spots: performanceTrend
                  .asMap()
                  .entries
                  .map(
                    (entry) =>
                        FlSpot(entry.key.toDouble(), entry.value.overallScore),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
