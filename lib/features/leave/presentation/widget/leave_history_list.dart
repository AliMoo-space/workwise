// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:gap/gap.dart'
// import 'package:workwise/core/design_system/spacing/app_radius.dart';
// import 'package:workwise/core/design_system/spacing/app_spacing.dart';
// import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
// import 'package:workwise/core/design_system/widgets/text/app_text.dart';
// import 'package:workwise/core/localization/localization_extension.dart';
// class LeaveHistoryList extends StatelessWidget {
//  const LeaveHistoryList({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return AppCard(
//           margin: EdgeInsets.only(bottom: AppSpacing.space8.h),
//           height: 80.h,
//           width: double.infinity,
//           padding: EdgeInsets.all(10.r),
//           backgroundColor: Theme.of(context).colorScheme.onError,
//           borderRadius: AppRadius.radius20.r,
//           border: Border.all(
//             color: Theme.of(context).colorScheme.outlineVariant,
//             width: .7.w,
//           ),
//           boxShadow: const [],
//           child: Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     context.l10n.annualLeave,
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                   AppText(
//                     "May 20 – May 24 · 5 days",
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Container(
//                 width: 110.w,
//                 height: 30.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(AppRadius.radius16.r),
//                   color: Theme.of(context).colorScheme.outlineVariant,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 10.h,
//                       width: 10.w,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.primary,
//                         borderRadius: BorderRadius.circular(
//                           AppRadius.radius16.r,
//                         ),
//                       ),
//                     ),
//                     Gap(AppSpacing.space8.w),
//                     AppText(
//                       context.l10n.approved,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
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
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';

class LeaveHistoryList extends StatelessWidget {
  const LeaveHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveHistoryCubit, LeaveHistoryState>(
      builder: (context, state) {
        if (state is LeaveHistoryInitial || state is LeaveHistoryLoading) {
          return _buildSkeleton(context);
        }

        if (state is LeaveHistorySuccess) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final history = state.history[index];

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
                            history.type,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          AppText(
                            '${history.startDate} – ${history.endDate} · ${history.days} days',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    Gap(AppSpacing.space8.w),

                    Container(
                      width: 110.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius16.r,
                        ),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius16.r,
                              ),
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          AppText(
                            context.l10n.approved,
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

        if (state is LeaveHistoryFailure) {
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
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
                        'Annual Leave',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      AppText(
                        'May 20 – May 24 · 5 days',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                Gap(AppSpacing.space8.w),

                Skeleton.replace(
                  replacement: Bone(
                    width: 110.w,
                    height: 30.h,
                    borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                  ),
                  child: Container(
                    width: 110.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.radius16.r),
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h, width: 10.w),
                        Gap(AppSpacing.space8.w),
                        AppText(
                          context.l10n.approved,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
