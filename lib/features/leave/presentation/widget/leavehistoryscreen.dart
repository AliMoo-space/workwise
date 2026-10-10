import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:workwise/core/design_system/widgets/app_bar/app_app_bar.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';

import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_state.dart';
import 'package:workwise/features/leave/presentation/widget/leave_history_list.dart';

class LeaveHistoryScreen extends StatelessWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LeaveHistoryCubit>()..getLeaveHistory(),
      child: Scaffold(
        appBar: AppAppBar(
          title: AppText(
            context.l10n.leaveHistory,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: SafeArea(
          child: BlocListener<LeaveHistoryCubit, LeaveHistoryState>(
            listener: (context, state) {
              if (state is LeaveHistoryFailure) {
                AppSnackBar.error(context, message: state.message);
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space16.w,
                vertical: AppSpacing.space16.h,
              ),
              child: BlocBuilder<LeaveHistoryCubit, LeaveHistoryState>(
                builder: (context, state) {
                  // Loading
                  if (state is LeaveHistoryInitial ||
                      state is LeaveHistoryLoading) {
                    return _buildLoading();
                  }

                  // Success
                  if (state is LeaveHistorySuccess) {
                    if (state.leaveRequests.isEmpty) {
                      return Center(
                        child: AppText(
                          context.l10n.noLeaveHistory,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return LeaveHistoryList(leaveHistory: state.leaveRequests);
                  }

                  // Failure
                  if (state is LeaveHistoryFailure) {
                    return AppErrorState(
                      message: state.message,
                      onRetry: () {
                        context.read<LeaveHistoryCubit>().getLeaveHistory();
                      },
                    );
                  }

                  return _buildLoading();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildLoading() {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFEDF1F4),
        highlightColor: Color(0xFFF9FAFB),
        duration: Duration(milliseconds: 1600),
      ),
      child: Column(
        children: [
          _buildHistoryCardSkeleton(),
          Gap(AppSpacing.space8.h),
          _buildHistoryCardSkeleton(),
          Gap(AppSpacing.space8.h),
          _buildHistoryCardSkeleton(),
          Gap(AppSpacing.space8.h),
          _buildHistoryCardSkeleton(),
        ],
      ),
    );
  }

  static Widget _buildHistoryCardSkeleton() {
    return AppCard(
      width: double.infinity,
      height: 80.h,
      padding: EdgeInsets.all(10.r),
      backgroundColor: const Color(0xFFF7F9FB),
      borderRadius: AppRadius.radius20.r,
      border: Border.all(color: const Color(0xFFD9E2EC), width: .7.w),
      boxShadow: const [],
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 100.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
                Gap(AppSpacing.space8.h),
                Bone(
                  width: 190.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(AppRadius.radius4.r),
                ),
              ],
            ),
          ),
          Gap(AppSpacing.space8.w),
          Bone(
            width: 85.w,
            height: 30.h,
            borderRadius: BorderRadius.circular(AppRadius.radius16.r),
          ),
        ],
      ),
    );
  }
}
