import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_icon_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/extensions/context_extensions.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/drawer/widgets/app_drawer/app_drawer.dart';
import 'package:workwise/features/home/presentation/widgets/attendance_card_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_grid_widget.dart';
import 'package:workwise/features/home/presentation/widgets/home_stats_section_widget.dart';
import 'package:workwise/core/routing/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onDrawerChanged});

  final ValueChanged<bool>? onDrawerChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AttendanceEntity? _lastAttendance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AttendanceCubit>().loadCurrentAttendance(
      isUserInitiated: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AttendanceCubit>().onAppResumed();
    }
  }

  SnackBarAction? _buildSettingsSnackBarAction(
    BuildContext context, {
    required bool canOpenLocationSettings,
    required bool canOpenAppSettings,
  }) {
    if (canOpenLocationSettings) {
      return SnackBarAction(
        label: context.l10n.openLocationSettings,
        onPressed: LocationHelper.openLocationSettings,
      );
    }
    if (canOpenAppSettings) {
      return SnackBarAction(
        label: context.l10n.openAppSettings,
        onPressed: LocationHelper.openAppSettings,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          _lastAttendance = state.attendance;
        } else if (state is AttendanceActionSuccess) {
          if (state.attendance != null) {
            _lastAttendance = state.attendance;
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          context.read<AttendanceCubit>().loadCurrentAttendance(
            isUserInitiated: false,
          );
        } else if (state is AttendanceFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.localizedMessage(context.l10n)),
                action: _buildSettingsSnackBarAction(
                  context,
                  canOpenLocationSettings: state.canOpenLocationSettings,
                  canOpenAppSettings: state.canOpenAppSettings,
                ),
              ),
            );
        } else if (state is AttendanceActionFailure) {
          _lastAttendance = state.attendance;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.localizedMessage(context.l10n)),
                action: _buildSettingsSnackBarAction(
                  context,
                  canOpenLocationSettings: state.canOpenLocationSettings,
                  canOpenAppSettings: state.canOpenAppSettings,
                ),
              ),
            );
        }
      },
      child: Scaffold(
        drawer: AppDrawer(),
        onDrawerChanged: widget.onDrawerChanged,
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          title: Text(context.l10n.homeScreen),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space12.w),
              child: AppIconButton(
                icon: Icons.notifications,
                variant: AppIconButtonVariant.outlined,
                onPressed: () => context.push(AppRoutes.notificationScreen),
                tooltip: context.l10n.notifications,
                iconSize: AppSpacing.space16.sp,
              ),
            ),
          ],
        ),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final currentAttendance = switch (state) {
              AttendanceSuccess(:final attendance) => attendance,
              AttendanceActionLoading(:final attendance) => attendance,
              AttendanceActionFailure(:final attendance) => attendance,
              AttendanceActionSuccess(:final attendance) =>
                attendance ?? _lastAttendance,
              _ => _lastAttendance,
            };

            final isLoading =
                state is AttendanceLoading ||
                state is AttendanceInitial ||
                (state is AttendanceActionSuccess && currentAttendance == null);

            final secondaryText = state is AttendanceFailure
                ? (state.canOpenLocationSettings
                      ? context.l10n.openLocationSettings
                      : state.canOpenAppSettings
                      ? context.l10n.openAppSettings
                      : null)
                : null;
            final secondaryAction = state is AttendanceFailure
                ? (state.canOpenLocationSettings
                      ? () {
                          LocationHelper.openLocationSettings();
                        }
                      : state.canOpenAppSettings
                      ? () {
                          LocationHelper.openAppSettings();
                        }
                      : null)
                : null;

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space16.w,
                  ),
                  child: Column(
                    children: [
                      Gap(AppSpacing.space24.h),

                      if (isLoading)
                        const AttendanceCardSkeleton()
                      else if (currentAttendance != null)
                        AttendanceCardWidget(
                          attendanceEntity: currentAttendance,
                          isActionLoading: state is AttendanceActionLoading,
                          onCheckIn: () => context
                              .read<AttendanceCubit>()
                              .checkInCurrentLocation(isUserInitiated: true),
                          onCheckOut: () =>
                              context.read<AttendanceCubit>().checkOut(),
                        )
                      else if (state is AttendanceFailure)
                        AppErrorState(
                          message: state.localizedMessage(context.l10n),
                          onRetry: () => context
                              .read<AttendanceCubit>()
                              .loadCurrentAttendance(isUserInitiated: true),
                          secondaryButtonText: secondaryText,
                          onSecondaryPressed: secondaryAction,
                        )
                      else
                        const SizedBox.shrink(),
                      Gap(AppSpacing.space24.h),

                      HomeStatsSectionWidget(
                        widgets: currentAttendance?.widgets,
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
          },
        ),
      ),
    );
  }
}
