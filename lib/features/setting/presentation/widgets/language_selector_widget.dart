import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String currentLanguage;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.currentLanguage,
    required this.languages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.radius20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLanguage,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          isDense: true,
          dropdownColor: theme.colorScheme.surface,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          items: languages.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: AppText(language),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}