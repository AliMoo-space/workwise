import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/localization/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =============================================
  // External Dependencies
  // =============================================

  final preferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(preferences);

  // =============================================
  // Data Layer
  // =============================================

  // =============================================
  // Domain Layer
  // =============================================

  // =============================================
  // Use Cases
  // =============================================

  // =============================================
  // Presentation Layer
  // =============================================

  sl.registerFactory<LocaleCubit>(() => LocaleCubit(sl()));
}
