import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

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
                    Container(
                      padding: EdgeInsets.all(AppSpacing.space4.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radius8.r,
                        ),
                      ),
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
                          color: Theme.of(context).colorScheme.outline,
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
                  alignment: Alignment.centerRight,
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacing.space16.r),
                    margin: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width * 0.73,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderRadius: AppRadius.radius16.r,
                    border: Border.all(color: Colors.transparent, width: 0),
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
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
              scrollDirection: Axis.horizontal,
              children: [
                ActionChip(
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius20.r),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  label: const AppText("What's my sick leave balance?"),
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
            borderRadius: AppRadius.radius0,
            border: Border.all(color: Colors.transparent, width: 0),
            boxShadow: const [],
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: "Ask about a policy or balance...",
                    fillColor: Theme.of(context).colorScheme.surface,
                    borderRadius: AppRadius.radius24.r,
                  ),
                ),

                Gap(AppSpacing.space8.w),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
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
