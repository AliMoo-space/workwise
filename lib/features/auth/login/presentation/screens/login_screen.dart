import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/login/logic/login_cubit.dart';
import 'package:workwise/features/auth/login/logic/login_state.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_form.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_header_widget.dart';
import 'package:workwise/features/auth/login/presentation/widgets/login_warning_banner.dart';
import 'package:workwise/features/auth/login/presentation/widgets/quick_sign_in_button.dart';



class LoginScreen extends StatelessWidget {
  final bool isSessionExpired;

  const LoginScreen({
    super.key,
    this.isSessionExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F8), 
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.go(AppRoutes.homeScreen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const LoginHeaderWidget(),
                    const SizedBox(height: 20),
                    if (isSessionExpired) ...[
                      const LoginWarningBanner(
                        message: 'Your session has expired. Please log in again to continue.',
                        isSessionExpired: true,
                      ),
                      const SizedBox(height: 16),
                    ] else if (state is LoginErrorState) ...[
                      const LoginWarningBanner(
                        message: 'Invalid credentials. Please try again.',
                        isSessionExpired: false,
                      ),
                      const SizedBox(height: 16),
                    ],

                    const LoginForm(),
                    const SizedBox(height: 24),

                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white12)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white12)),
                      ],
                    ),

                    QuickSignInButton(
                      onTap: () {
                      },
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
}