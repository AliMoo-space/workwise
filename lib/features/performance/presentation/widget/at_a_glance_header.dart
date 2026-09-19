import 'package:flutter/material.dart';

import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class AtAGlanceHeader extends StatelessWidget {
  const AtAGlanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: AppText(
        context.l10n.atAGlance,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
