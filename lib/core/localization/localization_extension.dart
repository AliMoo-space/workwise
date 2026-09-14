import 'package:flutter/widgets.dart';
import 'package:workwise/generated/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
