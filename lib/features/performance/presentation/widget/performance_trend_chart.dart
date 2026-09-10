import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';

class PerformanceTrendChart extends StatelessWidget {
  const PerformanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.white,
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
                  const titles = {
                    0: 'Apr',
                    1: 'May',
                    2: 'Jun',
                    3: 'Jul',
                    4: 'Aug',
                    5: 'Sep',
                  };
                  final text = titles[value.toInt()] ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
              color: AppColors.secondary,
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
