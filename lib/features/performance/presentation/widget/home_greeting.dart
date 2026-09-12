import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        localization.goodMorning,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
