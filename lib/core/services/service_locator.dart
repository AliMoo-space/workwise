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
import 'package:workwise/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:workwise/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:workwise/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:workwise/features/tasks/domain/usecases/add_submission_attachment_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/get_submission_details_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/submit_task_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/update_task_progress_usecase.dart';
import 'package:workwise/features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_cubit.dart';

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

  // =============================================
  // Tasks - Data Layer
  // =============================================

  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(
      remoteDataSource: sl<TasksRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // =============================================
  // Tasks - Use Cases
  // =============================================

  sl.registerLazySingleton<GetTasksUseCase>(
    () => GetTasksUseCase(repository: sl<TasksRepository>()),
  );

  sl.registerLazySingleton<UpdateTaskProgressUseCase>(
    () => UpdateTaskProgressUseCase(repository: sl<TasksRepository>()),
  );

  sl.registerLazySingleton<UpdateTaskStatusUseCase>(
    () => UpdateTaskStatusUseCase(repository: sl<TasksRepository>()),
  );

  sl.registerLazySingleton<SubmitTaskUseCase>(
    () => SubmitTaskUseCase(repository: sl<TasksRepository>()),
  );

  sl.registerLazySingleton<GetSubmissionDetailsUseCase>(
    () => GetSubmissionDetailsUseCase(repository: sl<TasksRepository>()),
  );

  sl.registerLazySingleton<AddSubmissionAttachmentUseCase>(
    () => AddSubmissionAttachmentUseCase(repository: sl<TasksRepository>()),
  );

  // =============================================
  // Tasks - Presentation Layer
  // =============================================

  sl.registerFactory<TasksCubit>(
    () => TasksCubit(
      getTasksUseCase: sl<GetTasksUseCase>(),
      updateTaskProgressUseCase: sl<UpdateTaskProgressUseCase>(),
      updateTaskStatusUseCase: sl<UpdateTaskStatusUseCase>(),
      submitTaskUseCase: sl<SubmitTaskUseCase>(),
      getSubmissionDetailsUseCase: sl<GetSubmissionDetailsUseCase>(),
      addSubmissionAttachmentUseCase: sl<AddSubmissionAttachmentUseCase>(),
    ),
  );

  // =============================================
  // Localization
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );
}
