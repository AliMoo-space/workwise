import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/performance/domain/goals/entities/goal.dart';

class PersonalGoalsList extends StatelessWidget {
  const PersonalGoalsList({super.key, required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.space24.h),
        child: AppText(
          context.l10n.noGoalsFound,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == goals.length - 1 ? 0 : AppSpacing.space12.h,
          ),
          child: GestureDetector(
            onTap: () {
              context.push('${AppRoutes.goalDetailsScreen}/${goal.id}');
            },
            child: AppCard(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.space16.r),
              backgroundColor: Theme.of(context).colorScheme.onError,
              borderRadius: AppRadius.radius20.r,
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: .7.w,
              ),
              boxShadow: const [],
              child: _buildGoalContent(context, goal),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalContent(BuildContext context, Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppText(
                goal.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            Gap(AppSpacing.space12.w),
            _buildStatus(context, goal.status),
          ],
        ),

        Gap(AppSpacing.space8.h),

        AppText(
          goal.description,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),

        Gap(AppSpacing.space16.h),

        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Gap(AppSpacing.space8.w),
            AppText(
              '${context.l10n.target} ${goal.targetDate}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatus(BuildContext context, String status) {
    return AppCard(
      width: 90.w,
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space8.w),
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      borderRadius: AppRadius.radius32.r,
      border: Border.all(color: Colors.transparent, width: 0),
      boxShadow: const [],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7.w,
            height: 7.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Gap(AppSpacing.space8.w),
          Flexible(
            child: AppText(
              status,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
