// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/AIAssistant/presentation/screens/career_coach.dart';
import 'package:workwise/features/AIAssistant/presentation/screens/policy_assistant.dart';

class AiAssistant extends StatefulWidget {
  const AiAssistant({super.key});

  @override
  State<AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistant> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,

        title: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.radius16.r),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),

            Gap(AppSpacing.space8.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.aiAssistant,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppText(
                    context.l10n.careerCoachingHrPolicySupport,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.space16.r),
          child: Column(
            children: [
              // Gap(AppSpacing.space16.h),
              AppCard(
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.all(AppSpacing.space4.r),
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: AppRadius.radius32.r,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                boxShadow: const [],
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentIndex == 0
                                ? Theme.of(context).colorScheme.onError
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius32.r,
                            ),
                          ),
                          child: AppText(context.l10n.careerCoach, maxLines: 1),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentIndex == 1
                                ? Theme.of(context).colorScheme.onError
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppRadius.radius32.r,
                            ),
                          ),
                          child: AppText(
                            context.l10n.policyAssistant,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(AppSpacing.space20.h),

              Expanded(
                child: currentIndex == 0
                    ? const CareerCoach()
                    : const PolicyAssistant(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
