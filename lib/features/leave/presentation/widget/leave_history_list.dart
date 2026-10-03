import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_state.dart';

class LeaveHistoryList extends StatelessWidget {
  const LeaveHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveHistoryCubit, LeaveHistoryState>(
      builder: (context, state) {
        if (state is LeaveHistoryLoading) {
          return Skeletonizer(enabled: true, child: _buildSkeleton(context));
        }

        if (state is LeaveHistoryFailure) {
          AppSnackBar.error(context, message: state.message);
        }

        if (state is LeaveHistorySuccess) {
          if (state.leaveHistory.isEmpty) {
            return Center(
              child: AppText(
                context.l10n.noLeaveHistory,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.leaveHistory.length,
            itemBuilder: (context, index) {
              final leave = state.leaveHistory[index];

              return AppCard(
                margin: EdgeInsets.only(bottom: AppSpacing.space8.h),
                height: 80.h,
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                backgroundColor: Theme.of(context).colorScheme.onError,
                borderRadius: AppRadius.radius20.r,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: .7.w,
                ),
                boxShadow: const [],
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            leave.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          AppText(
                            '${leave.startDate.day}/${leave.startDate.month} - '
                            '${leave.endDate.day}/${leave.endDate.month} · '
                            '${leave.days} days',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Gap(AppSpacing.space8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius16.r,
                        ),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: leave.status.toLowerCase() == 'approved'
                                  ? Theme.of(context).colorScheme.primary
                                  : leave.status.toLowerCase() == 'rejected'
                                  ? Theme.of(context).colorScheme.error
                                  : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          AppText(
                            leave.status,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => AppCard(
          margin: EdgeInsets.only(bottom: AppSpacing.space8.h),
          height: 80.h,
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          backgroundColor: Theme.of(context).colorScheme.onError,
          borderRadius: AppRadius.radius20.r,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: .7.w,
          ),
          boxShadow: const [],
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Annual Leave',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    AppText(
                      '01/10 - 05/10 · 5 days',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
