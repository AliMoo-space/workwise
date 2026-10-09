import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';

class AttendanceCardWidget extends StatefulWidget {
  const AttendanceCardWidget({
    super.key,
    required this.attendanceEntity,
    required this.onCheckIn,
    required this.onCheckOut,
  });
  final AttendanceEntity attendanceEntity;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  @override
  State<AttendanceCardWidget> createState() => _AttendanceCardWidgetState();
}

class _AttendanceCardWidgetState extends State<AttendanceCardWidget> {
  late Stream<int> _workedSecondsStream;

  bool get _isCheckedIn =>
      widget.attendanceEntity.checkInTime?.trim().isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    _workedSecondsStream = _createWorkedSecondsStream(
      widget.attendanceEntity.workedSeconds,
      widget.attendanceEntity.canCheckOut,
    );
  }

  @override
  void didUpdateWidget(covariant AttendanceCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attendanceEntity.workedSeconds !=
            widget.attendanceEntity.workedSeconds ||
        oldWidget.attendanceEntity.canCheckOut !=
            widget.attendanceEntity.canCheckOut) {
      _workedSecondsStream = _createWorkedSecondsStream(
        widget.attendanceEntity.workedSeconds,
        widget.attendanceEntity.canCheckOut,
      );
    }
  }

  Stream<int> _createWorkedSecondsStream(int initialSeconds, bool isCheckedIn) {
    if (!isCheckedIn) {
      return const Stream<int>.empty();
    }

    return Stream<int>.periodic(
      const Duration(seconds: 1),
      (tick) => initialSeconds + tick + 1,
    );
  }

  String _formatWorkedTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.primary.withValues(alpha: .9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  context.l10n.todayAttendance,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.disabled,
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AppCard(
                    height: AppSpacing.space40.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space12.w,
                    ),
                    backgroundColor: AppColors.outlineVariant.withValues(
                      alpha: .2,
                    ),
                    child: Center(
                      child: AppText(
                        widget.attendanceEntity.status,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(AppSpacing.space4.h),
          AppText(
            '${context.l10n.checkedInAt}${widget.attendanceEntity.checkInTime ?? '-'}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(AppSpacing.space12.h),
          StreamBuilder<int>(
            stream: _workedSecondsStream,
            initialData: widget.attendanceEntity.workedSeconds,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.onPrimary),
                  Gap(AppSpacing.space8.w),
                  Flexible(
                    child: AppText(
                      _formatWorkedTime(
                        snapshot.data ?? widget.attendanceEntity.workedSeconds,
                      ),
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                  Flexible(
                    child: AppText(
                      context.l10n.hoursWorked,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Gap(AppSpacing.space12.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.onPrimary),
              Gap(AppSpacing.space8.w),
              AppText(
                widget.attendanceEntity.isInsideRadius
                    ? context.l10n.insideOffice
                    : context.l10n.outsideOffice,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          Gap(AppSpacing.space12.h),
          AppButton(
            text: !_isCheckedIn ? context.l10n.checkIn : context.l10n.checkOut,
            backgroundColor: !_isCheckedIn
                ? AppColors.success
                : AppColors.outlineVariant.withValues(alpha: .4),
            onPressed: !_isCheckedIn
                ? widget.onCheckIn
                : widget.attendanceEntity.canCheckOut
                ? widget.onCheckOut
                : null,
            leading: Icon(
              !_isCheckedIn ? Icons.login : Icons.logout,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceCardSkeleton extends StatelessWidget {
  const AttendanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: AppCard(
        backgroundColor: AppColors.primary.withValues(alpha: .9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    context.l10n.todayAttendance,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.disabled,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AppCard(
                      height: AppSpacing.space40.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space12.w,
                      ),
                      backgroundColor: AppColors.outlineVariant.withValues(
                        alpha: .2,
                      ),
                      child: Center(
                        child: AppText(
                          'Loading',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Gap(AppSpacing.space4.h),

            AppText(
              context.l10n.checkedInAt,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            Gap(AppSpacing.space12.h),

            Row(
              children: [
                const Icon(Icons.access_time),
                Gap(AppSpacing.space8.w),
                AppText(
                  '03:20:51',
                  style: AppTextStyles.headlineMedium.copyWith(fontSize: 28.sp),
                ),
                Gap(AppSpacing.space8.w),
                AppText(
                  context.l10n.hoursWorked,
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),

            Gap(AppSpacing.space12.h),

            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                Gap(AppSpacing.space8.w),
                AppText(
                  context.l10n.insideOffice,
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),

            Gap(AppSpacing.space12.h),

            AppButton(text: context.l10n.checkOut, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
