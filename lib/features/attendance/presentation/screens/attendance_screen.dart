import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/empty_view/empty_view.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_loader.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_history_cubit.dart';
import 'package:workwise/features/attendance/presentation/widgets/attendance_history_item.dart';
import 'package:workwise/features/attendance/presentation/widgets/location_status_card.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  double? _latitude;
  double? _longitude;
  bool _locationUnavailable = false;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
    context.read<AttendanceHistoryCubit>().loadHistory(
      month: DateTime.now().month,
      year: DateTime.now().year,
    );
  }

  Future<void> _loadAttendance() async {
    final position = await LocationHelper.getCurrentPosition();
    if (!mounted) return;
    if (position == null) {
      setState(() => _locationUnavailable = true);
      return;
    }
    _latitude = position.latitude;
    _longitude = position.longitude;
    await context.read<AttendanceCubit>().loadAttendance(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<void> _checkIn() async {
    if (_latitude == null || _longitude == null) {
      await _loadAttendance();
      if (_latitude == null || _longitude == null || !mounted) return;
    }
    await context.read<AttendanceCubit>().checkIn(
      latitude: _latitude!,
      longitude: _longitude!,
    );
  }

  Future<void> _checkOut() {
    return context.read<AttendanceCubit>().checkOut(
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<AttendanceHistoryCubit>().loadHistory(
            month: DateTime.now().month,
            year: DateTime.now().year,
          );
        } else if (state is AttendanceFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppAppBar(
          title: Text(
            context.l10n.attendance,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading ||
                state is AttendanceInitial ||
                state is AttendanceActionSuccess) {
              if (_locationUnavailable) {
                return AppErrorState(
                  message: context.l10n.locationPermissionDenied,
                  onRetry: _loadAttendance,
                );
              }
              return const AppFullScreenLoader();
            }
            if (state is AttendanceFailure) {
              return AppErrorState(
                message: state.message,
                onRetry: _loadAttendance,
              );
            }
            final attendance = (state as AttendanceSuccess).attendance;
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space16.w,
                vertical: AppSpacing.space24.h,
              ),
              children: [
                // AppText(context.l10n.attendance, style: AppTextStyles.headlineLarge),
                // const Gap(AppSpacing.space4),
                // AppText(
                //   context.l10n.attendanceDescription,
                //   style: AppTextStyles.bodyMedium,
                //   color: AppColors.textSecondary,
                // ),
                // const Gap(AppSpacing.space20),
                LocationStatusCard(attendance: attendance),
                const Gap(AppSpacing.space20),
                if (attendance.canCheckIn)
                  AppButton(
                    text: context.l10n.checkIn,
                    onPressed: _checkIn,
                    leading: const Icon(
                      Icons.login,
                      color: AppColors.onPrimary,
                    ),
                  ),
                if (attendance.canCheckIn) const Gap(AppSpacing.space12),
                AppButton(
                  text: context.l10n.checkOut,
                  onPressed: attendance.canCheckOut ? _checkOut : null,
                  leading: const Icon(Icons.logout, color: AppColors.onPrimary),
                ),
                const Gap(AppSpacing.space20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        context.l10n.history,
                        style: AppTextStyles.headlineSmall,
                      ),
                    ),
                    const Gap(AppSpacing.space8),
                    Flexible(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                        label: Text(context.l10n.june2026),
                      ),
                    ),
                  ],
                ),
                const Gap(AppSpacing.space12),
                BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
                  builder: (context, historyState) {
                    if (historyState is AttendanceHistoryLoading ||
                        historyState is AttendanceHistoryInitial) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.space24,
                        ),
                        child: Center(child: AppLoader()),
                      );
                    }
                    if (historyState is AttendanceHistoryFailure) {
                      return AppErrorState(
                        message: historyState.message,
                        onRetry: () =>
                            context.read<AttendanceHistoryCubit>().loadHistory(
                              month: DateTime.now().month,
                              year: DateTime.now().year,
                            ),
                      );
                    }
                    final history = (historyState as AttendanceHistorySuccess)
                        .history
                        .history;
                    if (history.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.space24,
                        ),
                        child: EmptyView(
                          title: context.l10n.noAttendanceRecords,
                          message: context.l10n.noAttendanceRecordsMessage,
                        ),
                      );
                    }
                    return Column(
                      children: history
                          .map(
                            (record) => Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.space12,
                              ),
                              child: AttendanceHistoryItem(
                                date: '${record.dayName}, ${record.date}',
                                details:
                                    '${record.checkIn ?? '-'} - ${record.checkOut ?? '-'} · ${record.workedTime}',
                                status: record.status,
                                statusColor: record.isException
                                    ? AppColors.warning
                                    : AppColors.success,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
