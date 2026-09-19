import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLocale = context.watch<LocaleCubit>().state;

    return PopupMenuButton<Locale>(
      tooltip: context.l10n.language,
      initialValue: selectedLocale,
      onSelected: context.read<LocaleCubit>().setLocale,
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