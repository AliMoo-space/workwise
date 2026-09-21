import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class QuickSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const QuickSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: AppCard(
        onTap: onTap,
        borderRadius: AppRadius.radius20,
        backgroundColor: Theme.of(context).colorScheme.surface,
        border: Border.all(color: primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        child: Row(
          children: [
            Icon(Icons.fingerprint, color: primaryColor, size: 28.sp),
            Gap(AppSpacing.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.quickSignIn,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(AppSpacing.space2),
                  AppText(
                    context.l10n.useFingerprintOrFaceId,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
