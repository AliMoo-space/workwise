import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ReadContext, WatchContext;
import 'package:workwise/core/localization/locale_provider.dart';
import 'package:workwise/generated/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final selectedLocale = context.watch<LocaleProvider>().locale;

    return PopupMenuButton<Locale>(
      tooltip: localizations.language,
      initialValue: selectedLocale,
      onSelected: context.read<LocaleProvider>().setLocale,
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(localizations.languageEnglish),
        ),
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(localizations.languageArabic),
        ),
      ],
    );
  }
}
