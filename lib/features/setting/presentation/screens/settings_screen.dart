import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/features/setting/presentation/logic/setting_cubit.dart';
import 'package:workwise/features/setting/presentation/logic/setting_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<String> _languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = context.read<SettingsCubit>();

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(12.h),

                    // Biometric Login Card
                    _buildSettingCard(
                      theme: theme,
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric login',
                      subtitle: 'Fingerprint / Face ID',
                      trailing: Switch.adaptive(
                        value: cubit.isBiometricEnabled,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (val) => cubit.toggleBiometric(val),
                      ),
                    ),
                    Gap(12.h),

                    // Push Notifications Card
                    _buildSettingCard(
                      theme: theme,
                      icon: Icons.notifications_none_rounded,
                      title: 'Push notifications',
                      subtitle: 'Tasks, approvals, reminders',
                      trailing: Switch.adaptive(
                        value: cubit.isNotificationsEnabled,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (val) => cubit.toggleNotifications(val),
                      ),
                    ),
                    Gap(12.h),

                    // Language Selector Card
                    _buildSettingCard(
                      theme: theme,
                      icon: Icons.translate_rounded,
                      title: 'Language',
                      subtitle: 'App display language',
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: cubit.selectedLanguage,
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
                            items: _languages.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) cubit.changeLanguage(val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh, 
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Gap(2.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}