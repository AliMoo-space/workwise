// ignore_for_file: duplicate_import

import 'package:flutter/widgets.dart';
import 'package:workwise/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}