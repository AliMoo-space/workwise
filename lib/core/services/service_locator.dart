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
import 'package:workwise/features/auth/login/data/Repository/auth_repository.dart';
import 'package:workwise/features/auth/login/data/web_services/auth_api_service.dart';
import 'package:workwise/features/auth/login/data/web_services/permissions_api_service.dart';
import 'package:workwise/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:workwise/features/splash/presentation/cubit/splash_cubit.dart';
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
import 'package:workwise/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:workwise/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:workwise/features/profile/domain/repositories/profile_repository.dart';
import 'package:workwise/features/profile/presentation/cubit/profile_cubit.dart';

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
    () => LocalStorage(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(sl<FlutterSecureStorage>()),
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

  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  // =============================================
  // Auth
  // =============================================

  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<PermissionsApiService>(
    () => PermissionsApiService(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      authApiService: sl<AuthApiService>(),
      networkInfo: sl<NetworkInfo>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      authRepository: sl<AuthRepository>(),
      localStorage: sl<LocalStorage>(),
    ),
  );

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
    () => LeaveRepositoryImpl(remoteDataSource: sl<LeaveRemoteDataSource>()),
  );

  sl.registerLazySingleton<LeaveHistoryRepository>(
    () => LeaveHistoryRepositoryImpl(
      remoteDataSource: sl<LeaveHistoryRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  // =============================================
  // Leave - Use Cases
  // =============================================

  sl.registerLazySingleton<GetLeaveBalances>(
    () => GetLeaveBalances(sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<GetLeaveHistory>(
    () => GetLeaveHistory(sl<LeaveHistoryRepository>()),
  );

  // =============================================
  // Leave - Presentation Layer
  // =============================================

  sl.registerFactory<LeaveBalancesCubit>(
    () => LeaveBalancesCubit(getLeaveBalances: sl<GetLeaveBalances>()),
  );

  sl.registerFactory<LeaveHistoryCubit>(
    () => LeaveHistoryCubit(getLeaveHistory: sl<GetLeaveHistory>()),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));

  // =============================================
  // Localization
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );
}
