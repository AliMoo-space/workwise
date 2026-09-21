// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workwise/core/localization/local_cubit.dart';
// import 'package:workwise/core/localization/localization_extension.dart';

// class LanguageSelector extends StatelessWidget {
//   const LanguageSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final selectedLocale = context.watch<LocaleCubit>().state;

//     return PopupMenuButton<Locale>(
//       tooltip: context.l10n.language,
//       initialValue: selectedLocale,
//       onSelected: context.read<LocaleCubit>().setLocale,
//       icon: const Icon(Icons.language),
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           value: const Locale('en'),
//           child: Text(context.l10n.languageEnglish),
//         ),
//         PopupMenuItem(
//           value: const Locale('ar'),
//           child: Text(context.l10n.languageArabic),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLocale = context.read<LocaleCubit>().state;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.space20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مقبض الـ BottomSheet العلوي
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(AppSpacing.space16),

              AppText(
                context.l10n.language,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(AppSpacing.space16),

              _LanguageOptionCard(
                title: context.l10n.languageArabic,
                subtitle: 'العربية',
                isSelected: selectedLocale.languageCode == 'ar',
                onTap: () {
                  context.read<LocaleCubit>().setLocale(const Locale('ar'));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const Gap(AppSpacing.space12),

              // خيار اللغة الإنجليزية
              _LanguageOptionCard(
                title: context.l10n.languageEnglish,
                subtitle: 'English',
                isSelected: selectedLocale.languageCode == 'en',
                onTap: () {
                  context.read<LocaleCubit>().setLocale(const Locale('en'));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const Gap(AppSpacing.space12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showLanguageBottomSheet(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space8),
        child: Icon(
          Icons.language_rounded,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
          : theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: AppSpacing.space12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    AppText(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}