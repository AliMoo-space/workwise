import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_spacing.dart';
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
          const StrengthsTitle(),

          Gap(AppSpacing.space16),

          const StrengthCard(),

          Gap(AppSpacing.space8),

          Gap(AppSpacing.space8),

          const DevelopmentAreasTitle(),

          Gap(AppSpacing.space16),

          const DevelopmentAreaCard(),

          Gap(AppSpacing.space16),

          Gap(AppSpacing.space16),

          const ActionPlanTitle(),

          Gap(AppSpacing.space16),

          const ActionPlanCard(),

          Gap(AppSpacing.space16),
        ],
      ),
    );
  }
}
