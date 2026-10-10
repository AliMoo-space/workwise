import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/empty_view/empty_view.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_loader.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/extensions/context_extensions.dart';
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
  DateTime _selectedHistoryMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendance();
    context.read<AttendanceHistoryCubit>().loadHistory(
      month: _selectedHistoryMonth.month,
      year: _selectedHistoryMonth.year,
    );
  }

  Future<void> _loadAttendance() async {
    final position = await LocationHelper.getCurrentPosition();
    if (!mounted) return;
    if (position == null) {
      setState(() => _locationUnavailable = true);
      return;
    }
    if (!_isValidCoordinate(position.latitude, position.longitude)) {
      setState(() => _locationUnavailable = true);
      return;
    }
    setState(() => _locationUnavailable = false);
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
    return context.read<AttendanceCubit>().checkOut();
  }

  bool _isValidCoordinate(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  Future<void> _selectHistoryMonth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedHistoryMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selectedDate == null || !mounted) return;

    setState(() {
      _selectedHistoryMonth = DateTime(selectedDate.year, selectedDate.month);
    });
    await context.read<AttendanceHistoryCubit>().loadHistory(
      month: _selectedHistoryMonth.month,
      year: _selectedHistoryMonth.year,
    );
  }

  String _formatHistoryMonth(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMM(locale).format(_selectedHistoryMonth);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          _loadAttendance();
          context.read<AttendanceHistoryCubit>().loadHistory(
            month: _selectedHistoryMonth.month,
            year: _selectedHistoryMonth.year,
          );
        } else if (state is AttendanceFailure ||
            state is AttendanceActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is AttendanceFailure
                    ? state.message
                    : (state as AttendanceActionFailure).message,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppAppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,

          title: Text(
            context.l10n.attendance,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading || state is AttendanceInitial) {
              if (_locationUnavailable) {
                return AppErrorState(
                  message: context.l10n.locationPermissionDenied,
                  onRetry: _loadAttendance,
                );
              }
              return const _AttendanceScreenSkeleton();
            }
            if (state is AttendanceFailure) {
              return AppErrorState(
                message: state.message,
                onRetry: _loadAttendance,
              );
            }
            final attendance = switch (state) {
              AttendanceSuccess(:final attendance) => attendance,
              AttendanceActionLoading(:final attendance) => attendance,
              AttendanceActionFailure(:final attendance) => attendance,
              AttendanceActionSuccess(:final attendance)
                  when attendance != null =>
                attendance,
              _ => null,
            };
            if (attendance == null) {
              return AppErrorState(
                message: context.l10n.attendanceDescription,
                onRetry: _loadAttendance,
              );
            }
            final actionInProgress = state is AttendanceActionLoading;
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
                    onPressed: actionInProgress ? null : _checkIn,
                    leading: const Icon(
                      Icons.login,
                      color: AppColors.onPrimary,
                    ),
                  ),
                if (attendance.canCheckIn) const Gap(AppSpacing.space12),
                AppButton(
                  text: context.l10n.checkOut,
                  onPressed: attendance.canCheckOut && !actionInProgress
                      ? _checkOut
                      : null,
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
                        onPressed: _selectHistoryMonth,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                        label: Text(_formatHistoryMonth(context)),
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
                              month: _selectedHistoryMonth.month,
                              year: _selectedHistoryMonth.year,
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

class _AttendanceScreenSkeleton extends StatelessWidget {
  const _AttendanceScreenSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space24.h,
        ),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const Bone(height: 220),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.space16.w),
                  child: Row(
                    children: [
                      const Icon(Icons.near_me),
                      const Gap(AppSpacing.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.insideWorkplaceRadius),
                            const Gap(AppSpacing.space4),
                            Text(context.l10n.gpsAccuracy),
                          ],
                        ),
                      ),
                      Text(context.l10n.valid),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.space20),
          AppButton(
            text: context.l10n.checkIn,
            onPressed: null,
            leading: const Icon(Icons.login),
          ),
          const Gap(AppSpacing.space12),
          AppButton(
            text: context.l10n.checkOut,
            onPressed: null,
            leading: const Icon(Icons.logout),
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
              const Bone(width: 100, height: 20),
            ],
          ),
          const Gap(AppSpacing.space12),
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const Gap(AppSpacing.space12),
            AttendanceHistoryItem(
              date: context.l10n.attendanceDate1,
              details: context.l10n.attendanceDetails1,
              status: context.l10n.present,
              statusColor: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}
