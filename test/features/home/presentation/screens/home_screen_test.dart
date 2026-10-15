import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_action_entity.dart';
import 'package:workwise/features/attendance/domain/entities/attendance_entity.dart';
import 'package:workwise/features/attendance/domain/repo/attendance_repo.dart';
import 'package:workwise/features/attendance/domain/usecases/check_in.dart';
import 'package:workwise/features/attendance/domain/usecases/check_out.dart';
import 'package:workwise/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:workwise/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:workwise/features/home/presentation/screens/home_screen.dart';
import 'package:workwise/generated/app_localizations.dart';

class FakeAttendanceRepo implements AttendanceRepo {
  Either<Failure, AttendanceEntity>? todayResult;
  int todayCalls = 0;

  @override
  Future<Either<Failure, AttendanceEntity>> getTodayAttendance({
    required double latitude,
    required double longitude,
  }) async {
    todayCalls++;
    return todayResult!;
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AttendanceActionEntity>> checkOut({
    double? latitude,
    double? longitude,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late FakeAttendanceRepo fakeRepo;
  late AttendanceCubit cubit;

  setUp(() {
    fakeRepo = FakeAttendanceRepo();
    fakeRepo.todayResult = Right(
      AttendanceEntity(
        status: 'On Shift',
        checkInTime: '09:00 AM',
        checkOutTime: null,
        workedTime: '02:00:00',
        distanceMeters: 5.0,
        isInsideRadius: true,
        canCheckIn: false,
        canCheckOut: true,
      ),
    );

    cubit = AttendanceCubit(
      getTodayAttendance: GetTodayAttendance(attendanceRepo: fakeRepo),
      checkInUseCase: CheckIn(fakeRepo),
      checkOutUseCase: CheckOut(fakeRepo),
      locationAcquirer: ({
        bool isUserInitiated = false,
        bool allowLastKnownFallback = true,
      }) async {
        return LocationAcquireSuccess(
          coordinates: LocationCoordinates(
            latitude: 30.0444,
            longitude: 31.2357,
            accuracyMeters: 10.0,
            timestamp: DateTime(2026, 10, 10, 9),
          ),
        );
      },
      locationStatusChecker: () async {
        return const LocationStatusSnapshot(
          permissionState: LocationPermissionState.granted,
        );
      },
    );
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets('renders RefreshIndicator on HomeScreen and triggers refresh on pull', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(2000, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(1000, 2000),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BlocProvider<AttendanceCubit>.value(
            value: cubit,
            child: const HomeScreen(),
          ),
        ),
      ),
    );

    // Initial load happens on initState
    await tester.pumpAndSettle();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(fakeRepo.todayCalls, 1);

    // Pull down to trigger RefreshIndicator
    await tester.fling(find.byType(SingleChildScrollView), const Offset(0.0, 300.0), 1000.0);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify todayCalls incremented due to pull-to-refresh
    expect(fakeRepo.todayCalls, 2);
  });
}

