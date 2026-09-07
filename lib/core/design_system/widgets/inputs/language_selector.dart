import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:workwise/core/localization/locale_cubit.dart';
import 'package:workwise/generated/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final selectedLocale = context.watch<LocaleCubit>().state;

    return PopupMenuButton<Locale>(
      tooltip: localizations.language,
      initialValue: selectedLocale,
      onSelected: context.read<LocaleCubit>().setLocale,
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
