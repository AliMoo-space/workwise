// import 'package:flutter/material.dart';gggg
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:gap/gap.dart';
// import 'package:workwise/core/design_system/spacing/app_radius.dart';
// import 'package:workwise/core/design_system/spacing/app_spacing.dart';
// import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
// import 'package:workwise/core/design_system/widgets/text/app_text.dart';
// class LeaveBalancesCard extends StatelessWidget {
//   const LeaveBalancesCard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppCard(
//           height: 150.h,
//           width: 110.w,
//           padding: EdgeInsets.all(AppRadius.radius12.r),
//           backgroundColor: Theme.of(context).colorScheme.onError,
//           borderRadius: AppRadius.radius32.r,
//           border: Border.all(
//             color: Theme.of(context).colorScheme.outlineVariant,
//             width: 1.w,
//           ),
//           boxShadow: const [],
//           child: Column(
//             children: [
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "Annual",
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               Row(
//                 children: [
//                   AppText(
//                     "13",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   AppText("/21", style: Theme.of(context).textTheme.labelLarge),
//                 ],
//               ),
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "days left",
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               LinearProgressIndicator(
//                 value: 13 / 21,
//                 backgroundColor: Theme.of(context).colorScheme.outlineVariant,
//                 color: Theme.of(context).colorScheme.tertiary,
//                 minHeight: 8.0.h,
//                 borderRadius: BorderRadius.circular(AppRadius.radius12.r),
//               ),
//             ],
//           ),
//         ),
//         AppCard(
//           height: 150.h,
//           width: 110.w,
//           padding: EdgeInsets.all(AppRadius.radius12.r),
//           backgroundColor: Theme.of(context).colorScheme.onError,
//           borderRadius: AppRadius.radius32.r,
//           border: Border.all(
//             color: Theme.of(context).colorScheme.outlineVariant,
//             width: 1.w,
//           ),
//           boxShadow: const [],
//           child: Column(
//             children: [
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "Casual",
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               Row(
//                 children: [
//                   AppText(
//                     "4",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   AppText("/7", style: Theme.of(context).textTheme.labelLarge),
//                 ],
//               ),
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "days left",
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               LinearProgressIndicator(
//                 value: 13 / 25,
//                 backgroundColor: Theme.of(context).colorScheme.outlineVariant,
//                 color: Theme.of(context).colorScheme.tertiary,
//                 minHeight: 8.0.h,
//                 borderRadius: BorderRadius.circular(AppRadius.radius12.r),
//               ),
//             ],
//           ),
//         ),
//         AppCard(
//           height: 150.h,
//           width: 110.w,
//           padding: EdgeInsets.all(AppRadius.radius12.r),
//           backgroundColor: Theme.of(context).colorScheme.onError,
//           borderRadius: AppRadius.radius32.r,
//           border: Border.all(
//             color: Theme.of(context).colorScheme.outlineVariant,
//             width: 1.w,
//           ),
//           boxShadow: const [],
//           child: Column(
//             children: [
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "Sick",
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               Row(
//                 children: [
//                   AppText(
//                     "8",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   AppText("/10", style: Theme.of(context).textTheme.labelLarge),
//                 ],
//               ),
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: AppText(
//                   "days left",
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ),
//               Gap(AppSpacing.space12.h),
//               LinearProgressIndicator(
//                 value: 13 / 17,
//                 backgroundColor: Theme.of(context).colorScheme.outlineVariant,
//                 color: Theme.of(context).colorScheme.tertiary,
//                 minHeight: 8.0.h,
//                 borderRadius: BorderRadius.circular(AppRadius.radius12.r),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

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
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';

class LeaveBalancesCard extends StatelessWidget {
  const LeaveBalancesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveBalancesCubit, LeaveBalancesState>(
      listener: (context, state) {
        if (state is LeaveBalancesFailure) {
          debugPrint('Leave Balances Error: ${state.message}');
          AppSnackBar.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is LeaveBalancesInitial || state is LeaveBalancesLoading) {
          return _buildSkeleton(context);
        }

        if (state is LeaveBalancesSuccess) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: state.balances.map((balance) {
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
                        balance.type,
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
                          '/${balance.totalDays}',
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
                      minHeight: 8.h,
                      borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }

        if (state is LeaveBalancesFailure) {
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (index) => AppCard(
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
                    'Annual Leave',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Gap(AppSpacing.space12.h),
                Row(
                  children: [
                    AppText(
                      '13',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AppText(
                      '/21',
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
                Skeleton.replace(
                  replacement: Bone(
                    height: 8.h,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                  ),
                  child: LinearProgressIndicator(
                    value: 13 / 21,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant,
                    color: Theme.of(context).colorScheme.tertiary,
                    minHeight: 8.h,
                    borderRadius: BorderRadius.circular(AppRadius.radius12.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
