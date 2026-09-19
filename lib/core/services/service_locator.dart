import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/features/notification/data/repo/notification_repo_impl.dart';
import 'package:workwise/features/notification/domain/repo/notification_repo.dart';
import 'package:workwise/features/notification/domain/usecases/initialize_notification.dart';
import 'package:workwise/features/notification/domain/usecases/show_notification.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =============================================
  // External Dependencies
  // =============================================

  final preferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(preferences);

  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // =============================================
  // Data Layer
  // =============================================

  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(
      notificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
    ),
  );

  // =============================================
  // Domain Layer
  // =============================================

  // =============================================
  // Use Cases
  // =============================================
sl.registerLazySingleton<InitializeNotification>(
  () => InitializeNotification(sl<NotificationRepo>()),
);
sl.registerLazySingleton<ShowNotification>(
  () => ShowNotification(sl<NotificationRepo>()),
);
  // =============================================
  // Presentation Layer
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );
}