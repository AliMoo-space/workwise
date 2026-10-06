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

// =============================================
// Attendance
// =============================================

import 'package:workwise/features/attendance/data/datasource/attendance_remote_data_source.dart';
import 'package:workwise/features/attendance/data/repo/attendance_repo_impl.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';
import 'package:workwise/features/attendance/domain/usecases/check_in.dart';
import 'package:workwise/features/attendance/domain/usecases/check_out.dart';
import 'package:workwise/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';

// =============================================
// Auth
// =============================================

import 'package:workwise/features/auth/login/data/Repository/auth_repository.dart';
import 'package:workwise/features/auth/login/data/web_services/auth_api_service.dart';
import 'package:workwise/features/auth/login/data/web_services/permissions_api_service.dart';
import 'package:workwise/features/auth/login/presentation/cubit/login_cubit.dart';

// =============================================
// Splash
// =============================================

import 'package:workwise/features/splash/presentation/cubit/splash_cubit.dart';

// =============================================
// Leave
// =============================================

// Leave Balances
import 'package:workwise/features/leave/data/datasourse/leave_balance_remote_data_source.dart';
import 'package:workwise/features/leave/data/repo/leave_balance_repository_impl.dart';
import 'package:workwise/features/leave/domain/repo/leave_balance_repository.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_balances_use_case.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';

// Leave History
import 'package:workwise/features/leave/data/datasourse/leave_history_remote_data_source.dart';
import 'package:workwise/features/leave/data/repo/leave_history_repository_impl.dart';
import 'package:workwise/features/leave/domain/repo/leave_history_repository.dart';
import 'package:workwise/features/leave/domain/usecase/get_leave_history_use_case.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';

// Leave Request
import 'package:workwise/features/leave/data/datasourse/leave_remote_data_source.dart';
import 'package:workwise/features/leave/data/repo/leave_repository_impl.dart';
import 'package:workwise/features/leave/domain/repo/leave_repository.dart';
import 'package:workwise/features/leave/domain/usecase/create_leave_request_use_case.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_request/leave_request_cubit.dart';

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

// =============================================
// AI Assistant - Career Coach
// =============================================

import 'package:workwise/features/AIAssistant/data/datasource/career_coach_remote_data_source.dart';
import 'package:workwise/features/AIAssistant/data/repositories/career_coach_repository_impl.dart';

import 'package:workwise/features/AIAssistant/domain/repositories/career_coach_repository.dart';
import 'package:workwise/features/AIAssistant/domain/usecases/get_career_coach.dart';

import 'package:workwise/features/AIAssistant/presentation/cubit/career_coach_cubit.dart';

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
      baseUrl: ApiConstants.baseUrl,
      getToken: () async {
        return sl<SecureStorage>().getAccessToken();
      },
    ).create(),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(sl<Dio>()));

  sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());

  // =============================================
  // Attendance
  // =============================================
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<AttendanceRepo>(
    () => AttendanceRepoImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetTodayAttendance>(
    () => GetTodayAttendance(attendanceRepo: sl()),
  );
  sl.registerLazySingleton<CheckIn>(() => CheckIn(sl()));
  sl.registerLazySingleton<CheckOut>(() => CheckOut(sl()));
  sl.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(
      getTodayAttendance: sl(),
      checkIn: sl(),
      checkOut: sl(),
    ),
  );

  // =============================================
  // Localization
  // =============================================

  sl.registerFactory<LocaleCubit>(() => LocaleCubit(sl<SharedPreferences>()));

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
  // Leave Balances
  // ---------------------------------------------

  sl.registerLazySingleton<LeaveBalanceRemoteDataSource>(
    () => LeaveBalanceRemoteDataSourceImpl(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<LeaveBalanceRepository>(
    () => LeaveBalanceRepositoryImpl(sl<LeaveBalanceRemoteDataSource>()),
  );

  // ---------------------------------------------
  // Leave History
  // ---------------------------------------------

  sl.registerLazySingleton<LeaveHistoryRemoteDataSource>(
    () => LeaveHistoryRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<LeaveHistoryRepository>(
    () => LeaveHistoryRepositoryImpl(sl<LeaveHistoryRemoteDataSource>()),
  );

  // ---------------------------------------------
  // Leave Request
  // ---------------------------------------------

  sl.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSourceImpl(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(sl<LeaveRemoteDataSource>()),
  );

  // =============================================
  // Performance - Data Layer
  // =============================================

  sl.registerLazySingleton<PerformanceRemoteDataSource>(
    () => PerformanceRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(sl<PerformanceRemoteDataSource>()),
  );

  // =============================================
  // Goals - Data Layer
  // =============================================

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
  // AI Assistant - Data Layer
  // =============================================

  sl.registerLazySingleton<CareerCoachRemoteDataSource>(
    () => CareerCoachRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<CareerCoachRepository>(
    () => CareerCoachRepositoryImpl(
      remoteDataSource: sl<CareerCoachRemoteDataSource>(),
    ),
  );

  // =============================================
  // Use Cases
  // =============================================

  // ---------------------------------------------
  // Leave
  // ---------------------------------------------

  sl.registerLazySingleton<GetLeaveBalancesUseCase>(
    () => GetLeaveBalancesUseCase(sl<LeaveBalanceRepository>()),
  );

  sl.registerLazySingleton<GetLeaveHistoryUseCase>(
    () => GetLeaveHistoryUseCase(sl<LeaveHistoryRepository>()),
  );

  sl.registerLazySingleton<CreateLeaveRequestUseCase>(
    () => CreateLeaveRequestUseCase(sl<LeaveRepository>()),
  );

  // ---------------------------------------------
  // Performance
  // ---------------------------------------------

  sl.registerLazySingleton<GetPerformanceUseCase>(
    () => GetPerformanceUseCase(sl<PerformanceRepository>()),
  );

  // ---------------------------------------------
  // Goals
  // ---------------------------------------------

  sl.registerLazySingleton<GetGoals>(() => GetGoals(sl<GoalsRepository>()));

  sl.registerLazySingleton<GetGoalDetails>(
    () => GetGoalDetails(sl<GoalDetailsRepository>()),
  );

  // ---------------------------------------------
  // AI Assistant
  // ---------------------------------------------

  sl.registerLazySingleton<GetCareerCoach>(
    () => GetCareerCoach(sl<CareerCoachRepository>()),
  );

  // =============================================
  // Presentation - Cubits
  // =============================================

  // ---------------------------------------------
  // Leave
  // ---------------------------------------------

  sl.registerFactory<LeaveBalancesCubit>(
    () => LeaveBalancesCubit(
      getLeaveBalancesUseCase: sl<GetLeaveBalancesUseCase>(),
    ),
  );

  sl.registerFactory<LeaveHistoryCubit>(
    () => LeaveHistoryCubit(sl<GetLeaveHistoryUseCase>()),
  );

  sl.registerFactory<LeaveRequestCubit>(
    () => LeaveRequestCubit(
      createLeaveRequestUseCase: sl<CreateLeaveRequestUseCase>(),
    ),
  );

  // ---------------------------------------------
  // Performance
  // ---------------------------------------------

  sl.registerFactory<PerformanceCubit>(
    () => PerformanceCubit(getPerformanceUseCase: sl<GetPerformanceUseCase>()),
  );

  // ---------------------------------------------
  // Goals
  // ---------------------------------------------

  sl.registerFactory<GoalsCubit>(
    () => GoalsCubit(sl<GetGoals>(), sl<GetGoalDetails>()),
  );

  // ---------------------------------------------
  // AI Assistant
  // ---------------------------------------------

  sl.registerFactory<CareerCoachCubit>(
    () => CareerCoachCubit(getCareerCoach: sl<GetCareerCoach>()),
  );
}
