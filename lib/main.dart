import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/theme/app_theme.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/routing/router_generation_config.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/generated/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  
  runApp(BlocProvider(create: (_) => sl<LocaleCubit>(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;

    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouterGenerationConfig.goRouter,
        theme: AppTheme.light,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(child: child!),
        );
      },
    );
  }
}
