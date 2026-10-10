import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/constants/app_constants.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/dio/dio_factory.dart';
import 'package:workwise/core/network/dio_consumer.dart';
import 'package:workwise/core/network/network_info.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/auth/fingerprint/data/Repository/fingerprint_repository.dart';
import 'package:workwise/features/auth/fingerprint/data/web_services/fingerprint_api_service.dart';
import 'package:workwise/features/auth/fingerprint/presentation/cubit/finger_print_cubit.dart';

// =============================================
// Auth - Login
// =============================================
import 'package:workwise/features/auth/login/data/Repository/login_repository.dart';
import 'package:workwise/features/auth/login/data/web_services/login_api_service.dart';
import 'package:workwise/features/auth/login/data/web_services/permissions_api_service.dart';
import 'package:workwise/features/auth/login/presentation/cubit/login_cubit.dart';

// =============================================
// Auth - Forgot Password
// =============================================
import 'package:workwise/features/auth/forgot_password/data/Repository/forgot_password_repository.dart';
import 'package:workwise/features/auth/forgot_password/data/web_services/forgot_password_api_service.dart';
import 'package:workwise/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';

// =============================================
// Auth - Reset Password
// =============================================
import 'package:workwise/features/auth/reset_password/data/Repository/reset_password_repository.dart';
import 'package:workwise/features/auth/reset_password/data/web_services/reset_password_api_service.dart';
import 'package:workwise/features/setting/presentation/cubit/setting_cubit.dart';

// =============================================
// Splash
// =============================================
import 'package:workwise/features/splash/presentation/cubit/splash_cubit.dart';

// =============================================
// Leave
// =============================================
import 'package:workwise/features/leave/data/datasourse/leave_remote_data_source.dart';
import 'package:workwise/features/leave/data/datasourse/leave_history_remote_data_source.dart';
import 'package:workwise/features/leave/data/repo/leave_repository_impl.dart';
import 'package:workwise/features/leave/data/repo/leave_history_repository_impl.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_balances.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_history.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =============================================
  // External Dependencies
  // =============================================

  final preferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(preferences);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // =============================================
  // Core Storage
  // =============================================

  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(
      sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(
      sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<InternetConnectionChecker>(
    InternetConnectionChecker.createInstance,
  );

  // =============================================
  // Network
  // =============================================

  sl.registerLazySingleton<Dio>(
    () => DioFactory(
      baseUrl: AppConstants.baseUrl,
      getToken: () => sl<SecureStorage>().getAccessToken(),
    ).create(),
  );

  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(
      sl<Dio>(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl<InternetConnectionChecker>(),
    ),
  );

  // =============================================
  // Auth - Login
  // =============================================

  sl.registerLazySingleton<LoginApiService>(
    () => LoginApiService(
      sl<ApiConsumer>(),
    ),
  );

  sl.registerLazySingleton<PermissionsApiService>(
    () => PermissionsApiService(
      sl<ApiConsumer>(),
    ),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepository(
      loginApiService: sl<LoginApiService>(),
      networkInfo: sl<NetworkInfo>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );

sl.registerFactory<LoginCubit>(
  () => LoginCubit(
    loginRepository: sl<LoginRepository>(),
    localStorage: sl<LocalStorage>(),
  ),
);


  // =============================================
  // Auth - Forgot Password
  // =============================================

  sl.registerLazySingleton<ForgotPasswordApiService>(
    () => ForgotPasswordApiService(
      sl<ApiConsumer>(),
    ),
  );

  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepository(
      forgotPasswordApiService: sl<ForgotPasswordApiService>(),
    ),
  );

  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      forgotPasswordRepository: sl<ForgotPasswordRepository>(),
    ),
  );

  // =============================================
  // Auth - Reset Password
  // =============================================

  sl.registerLazySingleton<ResetPasswordApiService>(
    () => ResetPasswordApiService(
      sl<ApiConsumer>(),
    ),
  );

  sl.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepository(
      resetPasswordApiService: sl<ResetPasswordApiService>(),
    ),
  );


// =============================================
// Auth - Fingerprint
// =============================================

sl.registerLazySingleton<FingerprintApiService>(
  () => FingerprintApiService(
    sl<ApiConsumer>(),
  ),
);

sl.registerLazySingleton<FingerprintRepository>(
  () => FingerprintRepository(
    fingerprintApiService: sl<FingerprintApiService>(),
    secureStorage: sl<SecureStorage>(),
  ),
);

sl.registerFactory<FingerprintCubit>(
  () => FingerprintCubit(
    fingerprintRepository: sl<FingerprintRepository>(),
  ),
);

// =============================================
// Settings
// =============================================

sl.registerFactory<SettingsCubit>(
  () => SettingsCubit(
    fingerprintRepository: sl<FingerprintRepository>(),
  ),
);
  // =============================================
  // Splash
  // =============================================

  sl.registerFactory<SplashCubit>(
    () => SplashCubit(
      secureStorage: sl<SecureStorage>(),
      localStorage: sl<LocalStorage>(),
    ),
  );

  // =============================================
  // Leave - Data Layer
  // =============================================

  sl.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<LeaveHistoryRemoteDataSource>(
    () => LeaveHistoryRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(
      remoteDataSource: sl<LeaveRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<LeaveHistoryRepository>(
    () => LeaveHistoryRepositoryImpl(
      remoteDataSource: sl<LeaveHistoryRemoteDataSource>(),
    ),
  );

  // =============================================
  // Leave - Use Cases
  // =============================================

  sl.registerLazySingleton<GetLeaveBalances>(
    () => GetLeaveBalances(
      sl<LeaveRepository>(),
    ),
  );

  sl.registerLazySingleton<GetLeaveHistory>(
    () => GetLeaveHistory(
      sl<LeaveHistoryRepository>(),
    ),
  );

  // =============================================
  // Leave - Presentation Layer
  // =============================================

  sl.registerFactory<LeaveBalancesCubit>(
    () => LeaveBalancesCubit(
      getLeaveBalances: sl<GetLeaveBalances>(),
    ),
  );

  sl.registerFactory<LeaveHistoryCubit>(
    () => LeaveHistoryCubit(
      getLeaveHistory: sl<GetLeaveHistory>(),
    ),
  );

  // =============================================
  // Localization
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(
      sl<SharedPreferences>(),
    ),
  );
}
