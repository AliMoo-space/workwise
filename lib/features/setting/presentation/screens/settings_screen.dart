
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/inputs/language_selector.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_state.dart';
import 'package:workwise/features/setting/presentation/widgets/setting_tile_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SettingsCubit(),
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
          child: BlocBuilder<SettingsCubit, SettingsState>(
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
                    // عنوان قسم التفضيلات
                    AppText(
                      context.l10n.preferences,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(AppSpacing.space12),

                    // خيار تسجيل الدخول بالبصمة
                    SettingTileWidget(
                      icon: Icons.fingerprint_rounded,
                      title: context.l10n.biometricLogin,
                      subtitle: context.l10n.fingerprintFaceId,
                      trailing: Switch.adaptive(
                        value: cubit.isBiometricEnabled,
                        // ألوان حالة التفعيل (ON)
                        activeColor: Colors.white,
                        activeTrackColor: theme.colorScheme.primary,
                        // ألوان حالة الإيقاف (OFF)
                        inactiveThumbColor: theme.colorScheme.outline,
                        inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                        onChanged: (val) => cubit.toggleBiometric(val),
                      ),
                    ),
                    const Gap(AppSpacing.space12),

                    // خيار الإشعارات
                    SettingTileWidget(
                      icon: Icons.notifications_none_rounded,
                      title: context.l10n.pushNotifications,
                      subtitle: context.l10n.tasksApprovalsReminders,
                      trailing: Switch.adaptive(
                        value: cubit.isNotificationsEnabled,
                        // ألوان حالة التفعيل (ON)
                        activeColor: Colors.white,
                        activeTrackColor: theme.colorScheme.primary,
                        // ألوان حالة الإيقاف (OFF)
                        inactiveThumbColor: theme.colorScheme.outline,
                        inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                        onChanged: (val) => cubit.toggleNotifications(val),
                      ),
                    ),
                    const Gap(AppSpacing.space12),

                    // خيار تغيير اللغة
                    SettingTileWidget(
                      icon: Icons.translate_rounded,
                      title: context.l10n.language,
                      subtitle: context.l10n.appDisplayLanguage,
                      trailing: const LanguageSelector(),
                    ),

                    const Gap(AppSpacing.space24),
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