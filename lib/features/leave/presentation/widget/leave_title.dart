import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class LeaveTitle extends StatelessWidget {
  const LeaveTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        AppLocalizations.of(context).leave,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
