import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_state.dart';

class LeaveBalancesCard extends StatelessWidget {
  const LeaveBalancesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveBalancesCubit, LeaveBalancesState>(
      listener: (context, state) {
        if (state is LeaveBalancesFailure) {
          AppSnackBar.error(context, message: state.message);
        }
      },
      child: BlocBuilder<LeaveBalancesCubit, LeaveBalancesState>(
        builder: (context, state) {
          if (state is LeaveBalancesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LeaveBalancesSuccess) {
            if (state.balances.isEmpty) {
              return const SizedBox.shrink();
            }

            final balance = state.balances.first;

            return AppCard(
              height: 150.h,
              width: 110.w,
              padding: EdgeInsets.all(AppRadius.radius12.r),
              backgroundColor: Theme.of(context).colorScheme.onError,
              borderRadius: AppRadius.radius32.r,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1.w,
              ),
              boxShadow: const [],
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: AppText(
                      balance.leaveTypeName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),

                  Gap(AppSpacing.space12.h),

                  Row(
                    children: [
                      AppText(
                        '${balance.remainingDays}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      AppText(
                        '/${balance.allocatedDays}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),

                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: AppText(
                      'days left',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                  Gap(AppSpacing.space12.h),

                  LinearProgressIndicator(
                    value: balance.progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant,
                    color: Theme.of(context).colorScheme.tertiary,
                    minHeight: 8.0.h,
                    borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
