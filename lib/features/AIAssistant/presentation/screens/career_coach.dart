import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_title.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/development_area_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/development_areas_title.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/strength_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/strengths_title.dart';

class CareerCoach extends StatelessWidget {
  const CareerCoach({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StrengthsTitle(),

          Gap(15.h),

          StrengthCard(),

          Gap(10.h),

          Gap(10.h),

          DevelopmentAreasTitle(),

          Gap(15.h),

          DevelopmentAreaCard(),

          Gap(15.h),

          Gap(15.h),

          ActionPlanTitle(),

          Gap(15.h),

          ActionPlanCard(),

          Gap(15.h),
        ],
      ),
    );
  }
}
