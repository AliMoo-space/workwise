import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_icon_button.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/home/presentation/widgets/app_drawer_widget.dart';
import 'package:workwise/features/home/presentation/widgets/attendance_card_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_grid_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space12.w),
            child: AppIconButton(
              icon: Icons.notifications,
              variant: AppIconButtonVariant.outlined,
              onPressed: () {},
              tooltip: 'Notifications',
              iconSize: AppSpacing.space24.sp,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.space24.h),

              AttendanceCardWidget(),

              SizedBox(height: AppSpacing.space24.h),
              HomeStatsSectionWidget(),

              SizedBox(height: AppSpacing.space24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  'Quick Actions',
                  style: AppTextStyles.headlineMedium,
                ),
              ),
              SizedBox(height: AppSpacing.space16.h),

              HomeStatsGrid(),
              SizedBox(height: AppSpacing.space16.h),
            ],
          ),
        ),
      ),
    );
  }
}
