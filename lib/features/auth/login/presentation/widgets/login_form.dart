// ignore_for_file: dead_code, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/buttons/app_button.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart'; // مسار AppTextField
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/auth/login/logic/login_cubit.dart';
import 'package:workwise/features/auth/login/logic/login_state.dart';
import 'package:workwise/features/auth/login/presentation/widgets/reset_password_bottom_sheet.dart';
import 'package:workwise/generated/app_localizations.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final localization = AppLocalizations.of(context);

    return Form(
      key: cubit.formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: cubit.emailController,
              label: localization.workEmail,
              hintText: localization.workEmailHint,
              type: AppTextFieldType.email,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
                size: 20.sp,
              ),
              validator: AppValidators.email(
                emptyMessage: localization.enterWorkEmailMessage,
                invalidMessage: localization.invalidEmailFormatMessage,
              ),
            ),
            Gap(16.h),

            AppTextField(
              controller: cubit.passwordController,
              label: localization.password,
              hintText: localization.passwordHint,
              type: AppTextFieldType.password,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
                size: 20.sp,
              ),
              validator: AppValidators.password(
                emptyMessage: localization.enterPasswordMessage,
              ),
            ),
            Gap(16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (_, current) =>
                          current is LoginKeepMeSignedInState,
                      builder: (context, state) {
                        return SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Checkbox(
                            value: cubit.keepMeSignedIn,
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Theme.of(context).colorScheme.surface,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            onChanged: (val) => cubit.toggleKeepMeSignedIn(val),
                          ),
                        );
                      },
                    ),
                    Gap(8.w),
                    Text(
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      localization.keepMeSignedIn,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ResetPasswordBottomSheet.show(context);
                  },
                  child: Text(
                    localization.forgotPassword,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Gap(24.h),

            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return AppButton(
                  text: localization.signIn,
                  height: 52.h,
                  isLoading: state is LoginLoadingState,
                  onPressed: () => cubit.login(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
