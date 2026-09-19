import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class ResetPasswordHeaderWidget extends StatelessWidget {
  const ResetPasswordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Gap(AppSpacing.space20),
        Center(
          child: Icon(
            Icons.lock_reset_outlined,
            size: 70.sp,
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(AppSpacing.space24),
        AppText(
          'Create New Password',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Gap(AppSpacing.space8),
        AppText(
          'Your new password must be different from previously used passwords.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}