import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_dialog.dart';
import 'package:workwise/core/design_system/widgets/inputs/language_selector.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_state.dart';
import 'package:workwise/features/setting/presentation/widgets/setting_tile_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 60,
          title: Column(
            children: [
              AppText(
                context.l10n.settings,
                style: AppTextStyles.headlineLarge,
              ),
              const Gap(AppSpacing.space4),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            builder: (context, state) {
              final cubit = context.read<SettingsCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16,
                  vertical: AppSpacing.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.preferences,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(AppSpacing.space12),

                    // Biometric Login Tile
                    SettingTileWidget(
                      icon: Icons.fingerprint_rounded,
                      title: context.l10n.biometricLogin,
                      subtitle: context.l10n.fingerprintFaceId,
                      trailing: Switch.adaptive(
                        value: state.isBiometricEnabled,
                        onChanged: state.isBiometricLoading
                            ? null
                            : cubit.toggleBiometric,
                        activeColor: Colors.white,
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveThumbColor: theme.colorScheme.outline,
                        inactiveTrackColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),

                    if (state.isBiometricLoading) ...[
                      const Gap(AppSpacing.space8),
                      const LinearProgressIndicator(),
                    ],

                    const Gap(AppSpacing.space12),

                    // Language Selector Tile
                    SettingTileWidget(
                      icon: Icons.translate_rounded,
                      title: context.l10n.language,
                      subtitle: context.l10n.appDisplayLanguage,
                      trailing: const LanguageSelector(),
                    ),

                    const Gap(AppSpacing.space24),
                    _buildDeleteAccountButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildDeleteAccountButton(BuildContext context) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return AppButton(
    text: isArabic ? 'حذف الحساب' : 'Delete Account',
    variant: AppButtonVariant.danger,
    onPressed: () async {
      final confirmed = await AppDialog.confirm(
        context,
        title: isArabic ? 'حذف الحساب' : 'Delete Account',
        message: isArabic
            ? 'هل انت متأكد انك عايز تحذف حسابك؟ لا يمكن التراجع عن هذا الاجراء.'
            : 'Are you sure you want to delete your account? This action cannot be undone.',
        confirmText: isArabic ? 'حذف الحساب' : 'Delete Account',
        cancelText: isArabic ? 'الغاء' : 'Cancel',
      );

      if (!confirmed || !context.mounted) return;

      // TODO: Call the actual account deletion API here.
      // Only log out and navigate after the server confirms deletion.
    },
  );
}
