import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/inputs/language_selector.dart';
import 'package:workwise/generated/app_localizations.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.signIn),
        actions: const [LanguageSelector()],
      ),
      body: Center(child: Text(localizations.signInContent)),
    );
  }
}
