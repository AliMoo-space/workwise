import 'package:flutter/material.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      tooltip: context.l10n.language,
      onSelected: (locale) {},
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(context.l10n.languageEnglish),
        ),
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(context.l10n.languageArabic),
        ),
      ],
    );
  }
}
