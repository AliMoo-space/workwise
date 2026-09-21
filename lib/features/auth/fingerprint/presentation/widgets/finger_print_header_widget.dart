import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/media/app_assets.dart';
import 'package:workwise/core/design_system/widgets/media/app_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class FingerprintHeaderWidget extends StatelessWidget {
  const FingerprintHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Center(
            child: AppImage(
              assetPath: getImagePath('logo2'),
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space20,
            vertical: AppSpacing.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(AppSpacing.space24),
              AppText(
                context.l10n.welcomeBack,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(AppSpacing.space4),
              AppText(
                context.l10n.verifyYourIdentityToAccessYourAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}