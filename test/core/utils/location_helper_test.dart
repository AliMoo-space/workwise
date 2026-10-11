import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workwise/core/utils/location_helper.dart';
import 'package:workwise/generated/app_localizations_ar.dart';
import 'package:workwise/generated/app_localizations_en.dart';

class FakeLocationPlatformGateway implements LocationPlatformGateway {
  bool serviceEnabled = true;
  LocationPermission currentPermission = LocationPermission.whileInUse;
  LocationPermission permissionAfterRequest = LocationPermission.whileInUse;
  LocationAccuracyStatus accuracyStatus = LocationAccuracyStatus.precise;
  LocationAccuracyStatus temporaryFullAccuracyResult =
      LocationAccuracyStatus.precise;

  Object? serviceEnabledError;
  Object? checkPermissionError;
  Object? requestPermissionError;
  Object? accuracyError;
  Object? currentPositionError;
  final List<Object?> currentPositionAttempts = <Object?>[];

  Position? currentPosition;
  Position? lastKnownPosition;
  bool openAppSettingsResult = true;
  bool openLocationSettingsResult = true;

  @override
  TargetPlatform targetPlatform = TargetPlatform.android;

  DateTime currentTime = DateTime(2026, 10, 10, 9);

  int checkPermissionCalls = 0;
  int requestPermissionCalls = 0;
  int requestTemporaryFullAccuracyCalls = 0;
  int getCurrentPositionCalls = 0;
  int getLastKnownPositionCalls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

  @override
  DateTime now() => currentTime;

  @override
  Future<bool> isLocationServiceEnabled() async {
    if (serviceEnabledError != null) {
      throw serviceEnabledError!;
    }
    return serviceEnabled;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    checkPermissionCalls++;
    if (checkPermissionError != null) {
      throw checkPermissionError!;
    }
    return currentPermission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    requestPermissionCalls++;
    if (requestPermissionError != null) {
      throw requestPermissionError!;
    }
    currentPermission = permissionAfterRequest;
    return currentPermission;
  }

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    if (accuracyError != null) {
      throw accuracyError!;
    }
    return accuracyStatus;
  }

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    requestTemporaryFullAccuracyCalls++;
    accuracyStatus = temporaryFullAccuracyResult;
    return accuracyStatus;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    getCurrentPositionCalls++;
    if (currentPositionAttempts.isNotEmpty) {
      final attempt = currentPositionAttempts.removeAt(0);
      if (attempt is Position) {
        return attempt;
      }
      if (attempt != null) {
        throw attempt;
      }
    }
    if (currentPositionError != null) {
      throw currentPositionError!;
    }
    return currentPosition ?? _buildPosition(timestamp: currentTime);
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    getLastKnownPositionCalls++;
    return lastKnownPosition;
  }

  @override
  Future<bool> openAppSettings() async {
    openAppSettingsCalls++;
    return openAppSettingsResult;
  }

  @override
  Future<bool> openLocationSettings() async {
    openLocationSettingsCalls++;
    return openLocationSettingsResult;
  }
}

Position _buildPosition({
  double latitude = 30.0444,
  double longitude = 31.2357,
  double accuracy = 12.0,
  DateTime? timestamp,
}) {
  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: timestamp ?? DateTime(2026, 10, 10, 9),
    accuracy: accuracy,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

void main() {
  late FakeLocationPlatformGateway fakeGateway;

  setUp(() {
    fakeGateway = FakeLocationPlatformGateway();
    LocationHelper.setGatewayForTesting(fakeGateway);
  });

  tearDown(() {
    LocationHelper.resetStateForTesting(resetGateway: true);
  });

  group('Permission states & checkLocationStatus', () {
    test('returns serviceDisabled when GPS is off', () async {
      fakeGateway.serviceEnabled = false;

      final status = await LocationHelper.checkLocationStatus();

      expect(status.permissionState, LocationPermissionState.serviceDisabled);
      expect(status.errorType, LocationErrorType.serviceDisabled);
      expect(status.isReady, isFalse);
      expect(fakeGateway.checkPermissionCalls, 0);
    });

    test('returns notRequested when permission is denied initially', () async {
      fakeGateway.currentPermission = LocationPermission.denied;

      final status = await LocationHelper.checkLocationStatus();

      expect(status.permissionState, LocationPermissionState.notRequested);
      expect(status.errorType, LocationErrorType.permissionRequired);
      expect(status.isReady, isFalse);
    });

    test(
      'returns permanentlyDenied when permission is deniedForever',
      () async {
        fakeGateway.currentPermission = LocationPermission.deniedForever;

        final status = await LocationHelper.checkLocationStatus();

        expect(
          status.permissionState,
          LocationPermissionState.permanentlyDenied,
        );
        expect(status.errorType, LocationErrorType.permissionPermanentlyDenied);
        expect(status.isReady, isFalse);
      },
    );

    test(
      'never treats LocationPermission.unableToDetermine as granted',
      () async {
        fakeGateway.currentPermission = LocationPermission.unableToDetermine;

        final status = await LocationHelper.checkLocationStatus();

        expect(
          status.permissionState,
          LocationPermissionState.unableToDetermine,
        );
        expect(status.errorType, LocationErrorType.unableToDetermine);
        expect(status.isReady, isFalse);
      },
    );

    test(
      'returns approximateGranted when approximate location is granted',
      () async {
        fakeGateway.currentPermission = LocationPermission.whileInUse;
        fakeGateway.accuracyStatus = LocationAccuracyStatus.reduced;

        final status = await LocationHelper.checkLocationStatus();

        expect(
          status.permissionState,
          LocationPermissionState.approximateGranted,
        );
        expect(status.errorType, LocationErrorType.preciseLocationRequired);
        expect(status.isReady, isFalse);
      },
    );

    test(
      'returns granted and isReady when precise location is granted',
      () async {
        fakeGateway.currentPermission = LocationPermission.always;
        fakeGateway.accuracyStatus = LocationAccuracyStatus.precise;

        final status = await LocationHelper.checkLocationStatus();

        expect(status.permissionState, LocationPermissionState.granted);
        expect(status.errorType, isNull);
        expect(status.isReady, isTrue);
      },
    );

    test(
      'detects revoked permission when previously granted then denied in Settings',
      () async {
        fakeGateway.currentPermission = LocationPermission.whileInUse;
        await LocationHelper.checkLocationStatus();

        fakeGateway.currentPermission = LocationPermission.denied;
        final statusAfterRevoke = await LocationHelper.checkLocationStatus();

        expect(
          statusAfterRevoke.permissionState,
          LocationPermissionState.revoked,
        );
        expect(statusAfterRevoke.errorType, LocationErrorType.permissionDenied);
      },
    );

    test(
      'maps missing manifest definitions to configurationError state',
      () async {
        fakeGateway.checkPermissionError =
            const PermissionDefinitionsNotFoundException(
              'No location permissions are defined in the manifest.',
            );

        final status = await LocationHelper.checkLocationStatus();

        expect(
          status.permissionState,
          LocationPermissionState.configurationError,
        );
        expect(status.errorType, LocationErrorType.unexpected);
      },
    );
  });

  group('acquireCurrentLocation permission flows', () {
    test(
      'requests permission when notRequested and succeeds when granted',
      () async {
        fakeGateway.currentPermission = LocationPermission.denied;
        fakeGateway.permissionAfterRequest = LocationPermission.whileInUse;
        fakeGateway.currentPosition = _buildPosition(
          latitude: 30.05,
          longitude: 31.24,
          accuracy: 8.5,
        );

        final result = await LocationHelper.acquireCurrentLocation();

        expect(result, isA<LocationAcquireSuccess>());
        final success = result as LocationAcquireSuccess;
        expect(success.coordinates.latitude, 30.05);
        expect(success.coordinates.longitude, 31.24);
        expect(success.coordinates.accuracyMeters, 8.5);
        expect(success.coordinates.isFromLastKnown, isFalse);
        expect(fakeGateway.requestPermissionCalls, 1);
      },
    );

    test(
      'does not enter endless permission loop after user denies permission',
      () async {
        fakeGateway.currentPermission = LocationPermission.denied;
        fakeGateway.permissionAfterRequest = LocationPermission.denied;

        // First automatic request prompts once and fails with permissionDenied.
        final firstResult = await LocationHelper.acquireCurrentLocation(
          isUserInitiated: false,
        );
        expect(firstResult, isA<LocationAcquireFailure>());
        final firstFailure = firstResult as LocationAcquireFailure;
        expect(firstFailure.permissionState, LocationPermissionState.denied);
        expect(firstFailure.errorType, LocationErrorType.permissionDenied);
        expect(fakeGateway.requestPermissionCalls, 1);

        // Second non-user-initiated request does NOT prompt again.
        final secondResult = await LocationHelper.acquireCurrentLocation(
          isUserInitiated: false,
        );
        expect(secondResult, isA<LocationAcquireFailure>());
        final secondFailure = secondResult as LocationAcquireFailure;
        expect(secondFailure.permissionState, LocationPermissionState.denied);
        expect(fakeGateway.requestPermissionCalls, 1);

        // User-initiated retry prompts once more; if still denied, marks deniedRepeatedly.
        final thirdResult = await LocationHelper.acquireCurrentLocation(
          isUserInitiated: true,
        );
        expect(thirdResult, isA<LocationAcquireFailure>());
        final thirdFailure = thirdResult as LocationAcquireFailure;
        expect(
          thirdFailure.permissionState,
          LocationPermissionState.deniedRepeatedly,
        );
        expect(
          thirdFailure.errorType,
          LocationErrorType.permissionDeniedRepeatedly,
        );
        expect(thirdFailure.canOpenAppSettings, isTrue);
        expect(fakeGateway.requestPermissionCalls, 2);
      },
    );

    test(
      'handles permanent denial without calling requestPermission',
      () async {
        fakeGateway.currentPermission = LocationPermission.deniedForever;

        final result = await LocationHelper.acquireCurrentLocation(
          isUserInitiated: true,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(
          failure.permissionState,
          LocationPermissionState.permanentlyDenied,
        );
        expect(
          failure.errorType,
          LocationErrorType.permissionPermanentlyDenied,
        );
        expect(failure.canOpenAppSettings, isTrue);
        expect(fakeGateway.requestPermissionCalls, 0);
      },
    );

    test(
      'handles permission prompt cancellation / in-progress exception',
      () async {
        fakeGateway.currentPermission = LocationPermission.denied;
        fakeGateway.requestPermissionError =
            const PermissionRequestInProgressException(
              'A permission request is already in progress',
            );

        final result = await LocationHelper.acquireCurrentLocation(
          isUserInitiated: true,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(
          failure.permissionState,
          LocationPermissionState.requestCancelled,
        );
        expect(failure.errorType, LocationErrorType.temporarilyUnavailable);
      },
    );

    test('handles missing AndroidManifest permission definitions', () async {
      fakeGateway.currentPermission = LocationPermission.denied;
      fakeGateway.requestPermissionError =
          const PermissionDefinitionsNotFoundException(
            'No location permissions are defined in the manifest.',
          );

      final result = await LocationHelper.acquireCurrentLocation();

      expect(result, isA<LocationAcquireFailure>());
      final failure = result as LocationAcquireFailure;
      expect(
        failure.permissionState,
        LocationPermissionState.configurationError,
      );
      expect(failure.errorType, LocationErrorType.unexpected);
      expect(failure.diagnosticMessage, contains('manifest'));
    });

    test(
      'handles approximate location on Android by requiring precise location',
      () async {
        fakeGateway.targetPlatform = TargetPlatform.android;
        fakeGateway.currentPermission = LocationPermission.whileInUse;
        fakeGateway.accuracyStatus = LocationAccuracyStatus.reduced;

        final result = await LocationHelper.acquireCurrentLocation(
          requirePrecise: true,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(
          failure.permissionState,
          LocationPermissionState.approximateGranted,
        );
        expect(failure.errorType, LocationErrorType.preciseLocationRequired);
        expect(failure.canOpenAppSettings, isTrue);
      },
    );

    test(
      'requests temporary full accuracy on iOS when reduced accuracy is active',
      () async {
        fakeGateway.targetPlatform = TargetPlatform.iOS;
        fakeGateway.currentPermission = LocationPermission.whileInUse;
        fakeGateway.accuracyStatus = LocationAccuracyStatus.reduced;
        fakeGateway.temporaryFullAccuracyResult =
            LocationAccuracyStatus.precise;

        final result = await LocationHelper.acquireCurrentLocation(
          requirePrecise: true,
          isUserInitiated: true,
        );

        expect(result, isA<LocationAcquireSuccess>());
        expect(fakeGateway.requestTemporaryFullAccuracyCalls, 1);
      },
    );
  });

  group('acquireCurrentLocation retrieval & fallback scenarios', () {
    test(
      'retries once after a transient timeout and succeeds on second attempt',
      () async {
        fakeGateway.currentPositionAttempts.addAll([
          TimeoutException('Initial GPS fix timed out'),
          _buildPosition(latitude: 30.01, longitude: 31.21, accuracy: 15.0),
        ]);

        final result = await LocationHelper.acquireCurrentLocation();

        expect(result, isA<LocationAcquireSuccess>());
        expect(fakeGateway.getCurrentPositionCalls, 2);
      },
    );

    test(
      'uses fresh and accurate last-known position on timeout when allowed',
      () async {
        fakeGateway.currentPositionError = TimeoutException('GPS timeout');
        fakeGateway.lastKnownPosition = _buildPosition(
          latitude: 30.02,
          longitude: 31.22,
          accuracy: 20.0,
          timestamp: fakeGateway.currentTime.subtract(
            const Duration(seconds: 45),
          ),
        );

        final result = await LocationHelper.acquireCurrentLocation(
          allowLastKnownFallback: true,
        );

        expect(result, isA<LocationAcquireSuccess>());
        final success = result as LocationAcquireSuccess;
        expect(success.coordinates.isFromLastKnown, isTrue);
        expect(success.coordinates.latitude, 30.02);
      },
    );

    test(
      'never uses last-known position when allowLastKnownFallback is false (check-in)',
      () async {
        fakeGateway.currentPositionError = TimeoutException('GPS timeout');
        fakeGateway.lastKnownPosition = _buildPosition(
          latitude: 30.02,
          longitude: 31.22,
          accuracy: 10.0,
          timestamp: fakeGateway.currentTime,
        );

        final result = await LocationHelper.acquireCurrentLocation(
          allowLastKnownFallback: false,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(failure.errorType, LocationErrorType.timeout);
        expect(fakeGateway.getLastKnownPositionCalls, 0);
      },
    );

    test('rejects stale last-known position on timeout', () async {
      fakeGateway.currentPositionError = TimeoutException('GPS timeout');
      fakeGateway.lastKnownPosition = _buildPosition(
        latitude: 30.02,
        longitude: 31.22,
        accuracy: 10.0,
        timestamp: fakeGateway.currentTime.subtract(
          const Duration(minutes: 10),
        ),
      );

      final result = await LocationHelper.acquireCurrentLocation(
        allowLastKnownFallback: true,
      );

      expect(result, isA<LocationAcquireFailure>());
      final failure = result as LocationAcquireFailure;
      expect(failure.errorType, LocationErrorType.timeout);
    });

    test('rejects inaccurate live GPS coordinates (> 100m accuracy)', () async {
      fakeGateway.currentPosition = _buildPosition(
        latitude: 30.0444,
        longitude: 31.2357,
        accuracy: 250.0,
      );

      final result = await LocationHelper.acquireCurrentLocation(
        requirePrecise: true,
      );

      expect(result, isA<LocationAcquireFailure>());
      final failure = result as LocationAcquireFailure;
      expect(failure.errorType, LocationErrorType.preciseLocationRequired);
      expect(
        failure.permissionState,
        LocationPermissionState.approximateGranted,
      );
    });

    test(
      'rejects null-island (0.0, 0.0) uninitialized GPS coordinates',
      () async {
        fakeGateway.currentPosition = _buildPosition(
          latitude: 0.0,
          longitude: 0.0,
          accuracy: 5.0,
        );

        final result = await LocationHelper.acquireCurrentLocation(
          allowLastKnownFallback: false,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(failure.errorType, LocationErrorType.temporarilyUnavailable);
      },
    );

    test(
      'handles GPS turned off mid-acquisition without using last-known fallback',
      () async {
        fakeGateway.currentPositionError =
            const LocationServiceDisabledException();
        fakeGateway.lastKnownPosition = _buildPosition();

        final result = await LocationHelper.acquireCurrentLocation(
          allowLastKnownFallback: true,
        );

        expect(result, isA<LocationAcquireFailure>());
        final failure = result as LocationAcquireFailure;
        expect(
          failure.permissionState,
          LocationPermissionState.serviceDisabled,
        );
        expect(failure.errorType, LocationErrorType.serviceDisabled);
        expect(failure.canOpenLocationSettings, isTrue);
        expect(fakeGateway.getLastKnownPositionCalls, 0);
      },
    );

    test('handles permission revoked mid-acquisition', () async {
      fakeGateway.currentPositionError = const PermissionDeniedException(
        'Permission revoked by user while acquiring fix',
      );

      final result = await LocationHelper.acquireCurrentLocation();

      expect(result, isA<LocationAcquireFailure>());
      final failure = result as LocationAcquireFailure;
      expect(failure.permissionState, LocationPermissionState.denied);
      expect(failure.errorType, LocationErrorType.permissionDenied);
    });

    test('preserves original exception on unexpected plugin failure', () async {
      final platformError = PlatformException(
        code: 'LOCATION_PLUGIN_CRASH',
        message: 'Internal location provider error',
      );
      fakeGateway.currentPositionError = platformError;

      final result = await LocationHelper.acquireCurrentLocation(
        allowLastKnownFallback: false,
      );

      expect(result, isA<LocationAcquireFailure>());
      final failure = result as LocationAcquireFailure;
      expect(failure.errorType, LocationErrorType.temporarilyUnavailable);
      expect(failure.cause, same(platformError));
    });

    test(
      'localizedMessage returns non-empty English and Arabic strings for every LocationErrorType',
      () {
        final en = AppLocalizationsEn();
        final ar = AppLocalizationsAr();

        for (final errorType in LocationErrorType.values) {
          expect(errorType.localizedMessage(en).trim(), isNotEmpty);
          expect(errorType.localizedMessage(ar).trim(), isNotEmpty);
          expect(errorType.defaultMessage.trim(), isNotEmpty);
        }
      },
    );
  });
}
