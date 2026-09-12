import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/generated/app_localizations.dart';

class PersonalGoalsList extends StatelessWidget {
  const PersonalGoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 130.h,
          width: double.infinity.w,
          child: Card(
            color: Theme.of(context).colorScheme.onError,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: .7.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Complete Advanced\nSQL certification",
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                          ),
                          Text(
                            "${localization.target} Aug 2026",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      const Spacer(),

                      Container(
                        width: 100.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 8.h,
                              width: 8.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),

                            Gap(10.w),

                            Text(
                              localization.onTrack,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 13 / 25,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                          minHeight: 8.h,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      Gap(10.w),

                      Text(
                        "50%",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
