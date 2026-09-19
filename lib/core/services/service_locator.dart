import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workwise/core/localization/local_cubit.dart';

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

  // =============================================
  // Data Layer
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

  // =============================================
  // Presentation Layer
  // =============================================

  sl.registerFactory<LeaveBalancesCubit>(
    () => LeaveBalancesCubit(getLeaveBalances: sl<GetLeaveBalances>()),
  );

  sl.registerFactory<LeaveHistoryCubit>(
    () => LeaveHistoryCubit(getLeaveHistory: sl<GetLeaveHistory>()),
  );

  // =============================================
  // Localization
  // =============================================

  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );
}
