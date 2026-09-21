import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class PolicyAssistant extends StatelessWidget {
  const PolicyAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.space16.r),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      padding: EdgeInsets.all(AppSpacing.space4.r),
                      height: 25.h,
                      width: 25.w,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.outlineVariant,
                      borderRadius: AppRadius.radius8.r,
                      border: Border.all(color: Colors.transparent, width: 0),
                      boxShadow: const [],
                      child: Icon(
                        Icons.smart_toy_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    Gap(AppSpacing.space8.w),

                    Expanded(
                      child: AppCard(
                        padding: EdgeInsets.all(AppSpacing.space16.r),
                        backgroundColor: Theme.of(context).colorScheme.onError,
                        borderRadius: AppRadius.radius16.r,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        boxShadow: const [],
                        child: const AppText(
                          "Hi Omar, I'm your HR Policy Assistant. Ask me about leave policies, benefits, or your current balances.",
                        ),
                      ),
                    ),
                  ],
                ),

                Gap(AppSpacing.space12.h),

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacing.space16.r),
                    margin: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width * 0.73,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderRadius: AppRadius.radius16.r,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    boxShadow: const [],
                    child: AppText(
                      "How many annual leave days can I carry over to next year?",
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),

                Gap(AppSpacing.space12.h),
              ],
            ),
          ),

          SizedBox(
            height: 45.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // textDirection: Directionality.of(context),
              children: [
                ActionChip(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  label: const AppText("What's my sick leave balance?"),
                  onPressed: () {},
                ),

                Gap(AppSpacing.space8.w),

                ActionChip(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  label: const AppText(
                    "What are the maternity leave policies?",
                  ),
                  onPressed: () {},
                ),

                Gap(AppSpacing.space8.w),

                ActionChip(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  label: const AppText("How do I apply for paternity leave?"),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Gap(AppSpacing.space8.h),

          AppCard(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.space16.w,
              vertical: AppSpacing.space12.h,
            ),
            backgroundColor: Theme.of(context).colorScheme.onError,
            borderRadius: AppRadius.radius8.r,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            boxShadow: const [],
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: context.l10n.askAboutPolicyOrBalance,
                    fillColor: Theme.of(context).colorScheme.surface,
                    borderRadius: AppRadius.radius24.r,
                  ),
                ),

                Gap(AppSpacing.space8.w),

                AppCard(
                  padding: EdgeInsets.zero,
                  width: 48.w,
                  height: 48.h,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  borderRadius: AppRadius.radius24.r,
                  border: Border.all(color: Colors.transparent, width: 0),
                  boxShadow: const [],
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
