import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/generated/app_localizations.dart';

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(16.r),
      height: 180.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onError,
        borderRadius: BorderRadius.circular(16.r),
      ),
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
                    0: localization.april,
                    1: localization.may,
                    2: localization.june,
                    3: localization.july,
                    4: localization.august,
                    5: localization.september,
                  };

                  final text = titles[value.toInt()] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
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
