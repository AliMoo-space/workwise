import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/inputs/language_selector.dart';
import 'package:workwise/core/design_system/widgets/media/app_assets.dart';
import 'package:workwise/core/design_system/widgets/media/app_image.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الجزء العلوي الذي يحتوي على اللوجو وزر تغيير اللغة بخلفية شفافة
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AppImage(
                  assetPath: getImagePath('logo2'),
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: AppSpacing.space0,
                left: AppSpacing.space8,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: const LanguageSelector(),
                ),
              ),
            ],
          ),
        ),

        // الجزء السفلي الذي يحتوي على نصوص الترحيب
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space20,
            vertical: AppSpacing.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.l10n.welcomeBack,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              const Gap(AppSpacing.space4),
              AppText(
                context.l10n.signInWithCorporateCredentials,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}