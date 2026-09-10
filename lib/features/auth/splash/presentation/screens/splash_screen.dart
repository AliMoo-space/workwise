// ignore_for_file: dead_code, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/auth/splash/logic/splash_cubit.dart';
import 'package:workwise/features/auth/splash/logic/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..checkAuthSession(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnauthenticatedState) {
            // context.go(AppRoutes.loginScreen);
            context.go(AppRoutes.loginScreen);
          } else if (state is AuthenticatedState) {
            context.go(AppRoutes.homeScreen);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/logo.jpeg', 
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 1),
                Image.asset(
                  'assets/images/logo1.jpeg', 
                  width: 180,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'loading...',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}