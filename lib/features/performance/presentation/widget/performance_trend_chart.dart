import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space16.r),
      height: 180.h,
      backgroundColor: Theme.of(context).colorScheme.onError,
      borderRadius: AppRadius.radius16.r,
      border: Border.all(color: Colors.transparent, width: 0),
      boxShadow: const [],
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final titles = {
                    0: context.l10n.april,
                    1: context.l10n.may,
                    2: context.l10n.june,
                    3: context.l10n.july,
                    4: context.l10n.august,
                    5: context.l10n.september,
                  };

                  final text = titles[value.toInt()] ?? '';

                  return Padding(
                    padding: EdgeInsets.only(top: AppSpacing.space8.h),
                    child: AppText(
                      text,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                },
                interval: 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Theme.of(context).colorScheme.secondary,
              barWidth: 3.w,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 2),
                FlSpot(2, 1.8),
                FlSpot(3, 3),
                FlSpot(4, 3.2),
                FlSpot(5, 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
