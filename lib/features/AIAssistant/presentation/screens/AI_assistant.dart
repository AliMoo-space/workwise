// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/features/AIAssistant/presentation/screens/career_coach.dart';
import 'package:workwise/features/AIAssistant/presentation/screens/policy_assistant.dart';
import 'package:workwise/generated/app_localizations.dart';

class AiAssistant extends StatefulWidget {
  const AiAssistant({super.key});

  @override
  State<AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistant> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),

                  Gap(10.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.aiAssistant,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          localization.careerCoachingHrPolicySupport,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(15.h),

              Container(
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
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
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(localization.careerCoach, maxLines: 1),
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
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            localization.policyAssistant,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(20.h),

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
