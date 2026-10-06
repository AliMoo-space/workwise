import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_icon_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/app_drawer.dart';
import 'package:workwise/features/home/presentation/widgets/attendance_card_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_grid_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onDrawerChanged});

  final ValueChanged<bool>? onDrawerChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().loadCurrentAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      onDrawerChanged: widget.onDrawerChanged,
      appBar: AppBar(
        title: Text(context.l10n.homeScreen),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space12.w),
            child: AppIconButton(
              icon: Icons.notifications,
              variant: AppIconButtonVariant.outlined,
              onPressed: () {},
              tooltip: context.l10n.notifications,
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
              Gap(AppSpacing.space24.h),

              BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading ||
                      state is AttendanceInitial ||
                      state is AttendanceActionSuccess) {
                    return const AttendanceCardSkeleton();
                  }
                  if (state is AttendanceSuccess) {
                    return AttendanceCardWidget(
                      attendanceEntity: state.attendance,
                      onCheckOut: () =>
                          context.read<AttendanceCubit>().checkOut(),
                    );
                  }
                  if (state is AttendanceFailure) {
                    return AppErrorState(
                      message: state.message,
                      onRetry: context
                          .read<AttendanceCubit>()
                          .loadCurrentAttendance,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Gap(AppSpacing.space24.h),

              BlocBuilder<AttendanceCubit, AttendanceState>(
                builder: (context, state) => HomeStatsSectionWidget(
                  widgets: state is AttendanceSuccess
                      ? state.attendance.widgets
                      : null,
                ),
              ),

              Gap(AppSpacing.space24.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppText(
                  context.l10n.quickActions,
                  style: AppTextStyles.headlineMedium,
                ),
              ),
              Gap(AppSpacing.space16.h),

              HomeStatsGrid(),
              Gap(AppSpacing.space16.h),
            ],
          ),
        ),
      ),
    );
  }
}
