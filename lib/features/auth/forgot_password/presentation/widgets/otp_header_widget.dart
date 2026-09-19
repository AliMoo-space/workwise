import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class OtpHeaderWidget extends StatelessWidget {
  final String email;

  const OtpHeaderWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Gap(AppSpacing.space20),
        Icon(
          Icons.mark_email_read_outlined,
          size: 70.sp,
          color: theme.colorScheme.primary,
        ),
        const Gap(AppSpacing.space20),
        AppText(
          'Verify Your Email',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Gap(AppSpacing.space12),
        AppText(
          'Please enter the 6-digit code sent to\n$email',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}