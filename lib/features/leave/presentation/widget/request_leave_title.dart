import 'package:flutter/material.dart';
import 'package:workwise/generated/app_localizations.dart';

class RequestLeaveTitle extends StatelessWidget {
  const RequestLeaveTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Text(
        AppLocalizations.of(context).requestLeave,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
