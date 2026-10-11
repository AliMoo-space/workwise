import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/generated/app_localizations.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.buttonText,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? buttonText;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    final resolvedButtonText = buttonText ?? l10n?.retry ?? 'Retry';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
            const Gap(AppSpacing.space16),
            AppText(
              message,
              style: AppTextStyles.bodyMedium,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const Gap(AppSpacing.space24),
              AppButton(text: resolvedButtonText, onPressed: onRetry),
            ],
            if (onSecondaryPressed != null &&
                secondaryButtonText != null &&
                secondaryButtonText!.isNotEmpty) ...[
              const Gap(AppSpacing.space12),
              AppButton(
                text: secondaryButtonText!,
                variant: AppButtonVariant.outlined,
                onPressed: onSecondaryPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
