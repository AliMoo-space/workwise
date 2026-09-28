import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/constants/app_constants.dart';
import 'package:workwise/core/localization/local_cubit.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/dio/dio_factory.dart';
import 'package:workwise/core/network/dio_consumer.dart';
import 'package:workwise/core/network/network_info.dart';

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
import 'package:workwise/features/performance/data/goals/repositories/goals_repository_impl.dart';

import 'package:workwise/features/performance/domain/goals/repositories/goals_repository.dart';
import 'package:workwise/features/performance/domain/goals/usecases/get_goals.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =============================================
  // External Dependencies
  // =============================================

  final preferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(preferences);

  sl.registerLazySingleton<InternetConnectionChecker>(
    InternetConnectionChecker.createInstance,
  );

  // =============================================
  // Core
  // =============================================

  sl.registerLazySingleton<Dio>(
    () => DioFactory(baseUrl: AppConstants.baseUrl).create(),
  );

  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl<Dio>()));

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );

  // =============================================
  // Data Layer
  // =============================================

  // Leave

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

  // Performance

  sl.registerLazySingleton<PerformanceRemoteDataSource>(
    () => PerformanceRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(sl<PerformanceRemoteDataSource>()),
  );

  // Goals

  sl.registerLazySingleton<GoalsRemoteDataSource>(
    () => GoalsRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<GoalsRepository>(
    () => GoalsRepositoryImpl(sl<GoalsRemoteDataSource>()),
  );

  // =============================================
  // Domain Layer
  // =============================================

  // =============================================
  // Use Cases
  // =============================================

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

  // =============================================
  // Presentation Layer
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

  sl.registerFactory<GoalsCubit>(() => GoalsCubit(sl<GetGoals>()));

  // =============================================
  // Localization
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );
}
