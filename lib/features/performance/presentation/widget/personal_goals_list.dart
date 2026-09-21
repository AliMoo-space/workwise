import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PersonalGoalsList extends StatelessWidget {
  const PersonalGoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == 2 ? 0 : AppSpacing.space12.h,
          ),
          child: AppCard(
            height: 120.h,
            width: double.infinity.w,
            padding: EdgeInsets.all(AppSpacing.space8.r),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius20.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: .7.w,
            ),
            boxShadow: const [],
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Complete Advanced\nSQL certification",
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                        AppText(
                          "${context.l10n.target} Aug 2026",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppCard(
                      width: 100.w,
                      height: 35.h,
                      padding: EdgeInsets.zero,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.outlineVariant,
                      borderRadius: AppRadius.radius32.r,
                      border: Border.all(color: Colors.transparent, width: 0),
                      boxShadow: const [],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 8.h,
                            width: 8.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.radius16.r,
                              ),
                            ),
                          ),
                          Gap(AppSpacing.space8.w),
                          AppText(
                            context.l10n.onTrack,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.space16.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 13 / 25,
                        backgroundColor: AppColors.border,
                        minHeight: 8.h,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius8.r,
                        ),
                      ),
                    ),
                    Gap(AppSpacing.space8.w),
                    AppText(
                      "50%",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
