import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

import 'package:workwise/features/performance/domain/performance/entities/performance_entity.dart';

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key, required this.performanceTrend});

  final List<PerformanceTrendEntity> performanceTrend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (performanceTrend.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      height: 180.h,
      backgroundColor: theme.colorScheme.onError,
      borderRadius: AppRadius.radius16.r,
      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
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
                      style: theme.textTheme.labelMedium,
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
              color: theme.colorScheme.secondary,
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
