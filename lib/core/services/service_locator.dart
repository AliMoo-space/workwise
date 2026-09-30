import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/api_constants.dart';
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

// =============================================
// Performance
// =============================================

import 'package:workwise/features/performance/data/performance/datasources/performance_remote_data_source.dart';
import 'package:workwise/features/performance/data/performance/repositories/performance_repository_impl.dart';

import 'package:workwise/features/performance/domain/performance/repositories/performance_repository.dart';
import 'package:workwise/features/performance/domain/performance/use_cases/get_performance_use_case.dart';

import 'package:workwise/features/performance/presentation/cubit/goals/goals_cubit.dart';
import 'package:workwise/features/performance/presentation/cubit/performance/performance_cubit.dart';

// =============================================
// Goals
// =============================================

import 'package:workwise/features/performance/data/goals/datasources/goals_remote_data_source.dart';
import 'package:workwise/features/performance/data/goals/datasources/goal_details_remote_data_source.dart';

import 'package:workwise/features/performance/data/goals/repositories/goals_repository_impl.dart';
import 'package:workwise/features/performance/data/goals/repositories/goal_details_repository_impl.dart';

import 'package:workwise/features/performance/domain/goals/repositories/goals_repository.dart';
import 'package:workwise/features/performance/domain/goals/repositories/goal_details_repository.dart';

import 'package:workwise/features/performance/domain/goals/usecases/get_goals.dart';
import 'package:workwise/features/performance/domain/goals/usecases/get_goal_details.dart';

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
    () => DioFactory(
      baseUrl: ApiConstants.baseUrl,
      getToken: () {
        return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2hyLXN5c3RlbS5pcHR2ZGVtby5zZXJ2NWdyb3VwLmNvbS9hcGkvYXV0aC9sb2dpbiIsImlhdCI6MTc5MDU5MjE5OCwiZXhwIjoxNzkwNjc4NTk4LCJuYmYiOjE3OTA1OTIxOTgsImp0aSI6Im04aEpQck14QmRIUFdKZ3IiLCJzdWIiOiI0MCIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjciLCJyb2xlIjoiT3duZXIifQ.CbIoXehnJXd3TJMD2eNccavqkXwIUpyRiq7tzSoFs2w';
      },
    ).create(),
  );

  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  // =============================================
  // Localization
  // =============================================

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

  // ---------------------------------------------
  // Leave
  // ---------------------------------------------

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

  // ---------------------------------------------
  // Performance
  // ---------------------------------------------

  sl.registerLazySingleton<PerformanceRemoteDataSource>(
    () => PerformanceRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(sl<PerformanceRemoteDataSource>()),
  );

  // ---------------------------------------------
  // Goals
  // ---------------------------------------------

  sl.registerLazySingleton<GoalsRemoteDataSource>(
    () => GoalsRemoteDataSourceImpl(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<GoalsRepository>(
    () => GoalsRepositoryImpl(sl<GoalsRemoteDataSource>()),
  );

  // ---------------------------------------------
  // Goal Details
  // ---------------------------------------------

  sl.registerLazySingleton<GoalDetailsRemoteDataSource>(
    () => GoalDetailsRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<GoalDetailsRepository>(
    () => GoalDetailsRepositoryImpl(sl<GoalDetailsRemoteDataSource>()),
  );

  // =============================================
  // Leave - Use Cases
  // =============================================
  // Domain Layer
  // =============================================

  // ---------------------------------------------
  // Use Cases
  // ---------------------------------------------

  sl.registerLazySingleton<GetLeaveBalances>(
    () => GetLeaveBalances(sl<LeaveRepository>()),
  );

  sl.registerLazySingleton<GetLeaveHistory>(
    () => GetLeaveHistory(sl<LeaveHistoryRepository>()),
  );

  sl.registerLazySingleton<GetPerformanceUseCase>(
    () => GetPerformanceUseCase(sl<PerformanceRepository>()),
  );

  sl.registerLazySingleton<GetGoals>(() => GetGoals(sl<GoalsRepository>()));

  sl.registerLazySingleton<GetGoalDetails>(
    () => GetGoalDetails(sl<GoalDetailsRepository>()),
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

  sl.registerFactory<PerformanceCubit>(
    () => PerformanceCubit(getPerformanceUseCase: sl<GetPerformanceUseCase>()),
  );

  sl.registerFactory<GoalsCubit>(
    () => GoalsCubit(sl<GetGoals>(), sl<GetGoalDetails>()),
  );
}
