import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workwise/generated/app_localizations.dart';

/// Represents all location permission and service states handled by WorkWise.
enum LocationPermissionState {
  /// Permission has not been requested yet in the current session.
  notRequested,

  /// Location permission is granted with sufficient (precise) accuracy.
  granted,

  /// Location permission is granted, but only approximate/reduced accuracy is enabled.
  approximateGranted,

  /// Location permission was denied by the user (can be requested again on explicit action).
  denied,

  /// Location permission was denied repeatedly by the user.
  deniedRepeatedly,

  /// Location permission is permanently denied or restricted by the OS/device policy.
  permanentlyDenied,

  /// Location permission was previously granted and later revoked in system settings.
  revoked,

  /// Device location services (GPS) are disabled.
  serviceDisabled,

  /// Permission status could not be determined by the platform.
  unableToDetermine,

  /// User cancelled or dismissed the permission prompt before completing it.
  requestCancelled,

  /// Platform configuration (e.g. AndroidManifest.xml or Info.plist) is missing required definitions.
  configurationError,

  /// An unexpected platform/plugin error occurred while checking or requesting permission.
  error,
}

/// Categorizes location acquisition and permission errors for UI presentation and recovery.
enum LocationErrorType {
  permissionRequired,
  permissionDenied,
  permissionDeniedRepeatedly,
  permissionPermanentlyDenied,
  serviceDisabled,
  preciseLocationRequired,
  unableToDetermine,
  timeout,
  temporarilyUnavailable,
  unexpected;

  /// Default English fallback message used when no `BuildContext` / `AppLocalizations` is available.
  String get defaultMessage => switch (this) {
    LocationErrorType.permissionRequired =>
      'Location permission is required to verify your workplace attendance.',
    LocationErrorType.permissionDenied =>
      'Location permission was denied. Please grant location access to verify attendance.',
    LocationErrorType.permissionDeniedRepeatedly =>
      'Location permission was denied multiple times. Please enable it in App Settings or tap retry.',
    LocationErrorType.permissionPermanentlyDenied =>
      'Location permission is permanently denied. Please open App Settings and allow location access while using the app.',
    LocationErrorType.serviceDisabled =>
      'Please enable GPS/location services on your device.',
    LocationErrorType.preciseLocationRequired =>
      'Precise location is required to verify workplace attendance. Please enable Precise Location in App Settings.',
    LocationErrorType.unableToDetermine =>
      'Unable to determine your current location. Please check your location settings and try again.',
    LocationErrorType.timeout =>
      'Location request timed out. Please move to an area with a clearer GPS signal and try again.',
    LocationErrorType.temporarilyUnavailable =>
      'Your current location is temporarily unavailable. Please wait a moment and try again.',
    LocationErrorType.unexpected =>
      'An unexpected error occurred while retrieving your location. Please try again.',
  };

  /// Localized message for the current [AppLocalizations].
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    LocationErrorType.permissionRequired => l10n.locationPermissionRequired,
    LocationErrorType.permissionDenied => l10n.locationPermissionDeniedMessage,
    LocationErrorType.permissionDeniedRepeatedly =>
      l10n.locationPermissionDeniedRepeatedly,
    LocationErrorType.permissionPermanentlyDenied =>
      l10n.locationPermissionPermanentlyDenied,
    LocationErrorType.serviceDisabled => l10n.locationServiceDisabled,
    LocationErrorType.preciseLocationRequired => l10n.locationPreciseRequired,
    LocationErrorType.unableToDetermine => l10n.locationUnableToDetermine,
    LocationErrorType.timeout => l10n.locationTimeout,
    LocationErrorType.temporarilyUnavailable =>
      l10n.locationTemporarilyUnavailable,
    LocationErrorType.unexpected => l10n.locationUnexpectedError,
  };

  /// Whether the user should be offered an action to open App Settings.
  bool get canOpenAppSettings =>
      this == LocationErrorType.permissionPermanentlyDenied ||
      this == LocationErrorType.permissionDeniedRepeatedly ||
      this == LocationErrorType.preciseLocationRequired;

  /// Whether the user should be offered an action to open device Location Settings (GPS).
  bool get canOpenLocationSettings => this == LocationErrorType.serviceDisabled;
}

/// Validated geographic coordinates with accuracy and timestamp metadata.
class LocationCoordinates extends Equatable {
  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    this.timestamp,
    this.isFromLastKnown = false,
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final DateTime? timestamp;
  final bool isFromLastKnown;

  bool get isValid => LocationHelper.isValidCoordinate(latitude, longitude);

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    accuracyMeters,
    timestamp,
    isFromLastKnown,
  ];
}

/// Snapshot of the current location service and permission status without prompting.
class LocationStatusSnapshot extends Equatable {
  const LocationStatusSnapshot({
    required this.permissionState,
    this.errorType,
    this.diagnosticMessage,
  });

  final LocationPermissionState permissionState;
  final LocationErrorType? errorType;
  final String? diagnosticMessage;

  bool get isReady =>
      permissionState == LocationPermissionState.granted && errorType == null;

  @override
  List<Object?> get props => [permissionState, errorType, diagnosticMessage];
}

/// Result of attempting to acquire the user's current location.
sealed class LocationAcquireResult extends Equatable {
  const LocationAcquireResult();
}

final class LocationAcquireSuccess extends LocationAcquireResult {
  const LocationAcquireSuccess({
    required this.coordinates,
    this.permissionState = LocationPermissionState.granted,
    this.position,
  });

  final LocationCoordinates coordinates;
  final LocationPermissionState permissionState;
  final Position? position;

  @override
  List<Object?> get props => [coordinates, permissionState, position];
}

final class LocationAcquireFailure extends LocationAcquireResult {
  LocationAcquireFailure({
    required this.errorType,
    required this.permissionState,
    String? message,
    this.diagnosticMessage,
    this.cause,
  }) : message = message ?? errorType.defaultMessage;

  final LocationErrorType errorType;
  final LocationPermissionState permissionState;
  final String message;
  final String? diagnosticMessage;
  final Object? cause;

  bool get canOpenAppSettings => errorType.canOpenAppSettings;

  bool get canOpenLocationSettings => errorType.canOpenLocationSettings;

  @override
  List<Object?> get props => [
    errorType,
    permissionState,
    message,
    diagnosticMessage,
  ];
}

/// Abstraction over platform location APIs to allow deterministic unit testing.
abstract interface class LocationPlatformGateway {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<LocationAccuracyStatus> getLocationAccuracy();
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  });
  Future<Position> getCurrentPosition({LocationSettings? locationSettings});
  Future<Position?> getLastKnownPosition();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
  TargetPlatform get targetPlatform;
  DateTime now();
}

/// Default production implementation of [LocationPlatformGateway] backed by [Geolocator].
class GeolocatorPlatformGateway implements LocationPlatformGateway {
  const GeolocatorPlatformGateway();

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Geolocator.getLocationAccuracy();

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) => Geolocator.requestTemporaryFullAccuracy(purposeKey: purposeKey);

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) =>
      Geolocator.getCurrentPosition(locationSettings: locationSettings);

  @override
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  TargetPlatform get targetPlatform => defaultTargetPlatform;

  @override
  DateTime now() => DateTime.now();
}

/// Centralized, reusable location permission and acquisition helper for WorkWise.
abstract final class LocationHelper {
  const LocationHelper._();

  static const String temporaryAccuracyPurposeKey = 'AttendanceVerification';
  static const double defaultMaxAcceptableAccuracyMeters = 100.0;
  static const Duration defaultMaxLastKnownAge = Duration(minutes: 2);
  static const Duration defaultAcquireTimeout = Duration(seconds: 10);
  static const Duration defaultPermissionRequestTimeout = Duration(seconds: 30);

  static LocationPlatformGateway _gateway = const GeolocatorPlatformGateway();

  static bool _hasRequestedPermissionInSession = false;
  static bool _hadGrantedPermission = false;
  static int _denialCount = 0;
  static Future<LocationPermission>? _inFlightPermissionRequest;
  static Future<LocationAcquireResult>? _inFlightAcquireRequest;

  /// Current [LocationPlatformGateway].
  static LocationPlatformGateway get gateway => _gateway;

  /// Number of times permission has been denied in the current session.
  static int get denialCount => _denialCount;

  /// Whether permission has been requested at least once in the current session.
  static bool get hasRequestedPermissionInSession =>
      _hasRequestedPermissionInSession;

  /// Whether permission was previously granted during the current session.
  static bool get hadGrantedPermission => _hadGrantedPermission;

  /// Overrides the platform gateway for unit testing and resets internal state.
  @visibleForTesting
  static void setGatewayForTesting(LocationPlatformGateway gateway) {
    _gateway = gateway;
    resetStateForTesting();
  }

  /// Resets internal session tracking state (for unit tests).
  @visibleForTesting
  static void resetStateForTesting({bool resetGateway = false}) {
    if (resetGateway) {
      _gateway = const GeolocatorPlatformGateway();
    }
    _hasRequestedPermissionInSession = false;
    _hadGrantedPermission = false;
    _denialCount = 0;
    _inFlightPermissionRequest = null;
    _inFlightAcquireRequest = null;
  }

  /// Validates that [latitude] and [longitude] are finite, within geographic bounds,
  /// and not an uninitialized `(0.0, 0.0)` null-island reading.
  static bool isValidCoordinate(double latitude, double longitude) {
    if (!latitude.isFinite || !longitude.isFinite) return false;
    if (latitude < -90 || latitude > 90) return false;
    if (longitude < -180 || longitude > 180) return false;
    if (latitude == 0.0 && longitude == 0.0) return false;
    return true;
  }

  /// Opens the OS application settings screen so the user can update permissions.
  static Future<bool> openAppSettings() async {
    try {
      return await _gateway.openAppSettings();
    } catch (e) {
      _logDiagnostic('Failed to open app settings: ${e.runtimeType}');
      return false;
    }
  }

  /// Opens the OS location settings screen so the user can enable GPS/location services.
  static Future<bool> openLocationSettings() async {
    try {
      return await _gateway.openLocationSettings();
    } catch (e) {
      _logDiagnostic('Failed to open location settings: ${e.runtimeType}');
      return false;
    }
  }

  /// Inspects the current location service, permission, and accuracy status
  /// WITHOUT prompting the user with a system permission dialog.
  ///
  /// Ideal for revalidating state when the app resumes from background/Settings.
  static Future<LocationStatusSnapshot> checkLocationStatus({
    bool requirePrecise = true,
  }) async {
    try {
      final serviceEnabled = await _gateway.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logDiagnostic('Status check: location services disabled.');
        return const LocationStatusSnapshot(
          permissionState: LocationPermissionState.serviceDisabled,
          errorType: LocationErrorType.serviceDisabled,
          diagnosticMessage: 'Location services are disabled on the device.',
        );
      }

      final permission = await _gateway.checkPermission();
      switch (permission) {
        case LocationPermission.denied:
          if (_hadGrantedPermission) {
            _logDiagnostic('Status check: permission was revoked.');
            return const LocationStatusSnapshot(
              permissionState: LocationPermissionState.revoked,
              errorType: LocationErrorType.permissionDenied,
              diagnosticMessage:
                  'Location permission was revoked while the app was running or in Settings.',
            );
          }
          if (!_hasRequestedPermissionInSession) {
            return const LocationStatusSnapshot(
              permissionState: LocationPermissionState.notRequested,
              errorType: LocationErrorType.permissionRequired,
              diagnosticMessage: 'Location permission has not been requested.',
            );
          }
          if (_denialCount >= 2) {
            return const LocationStatusSnapshot(
              permissionState: LocationPermissionState.deniedRepeatedly,
              errorType: LocationErrorType.permissionDeniedRepeatedly,
              diagnosticMessage:
                  'Location permission was denied repeatedly in this session.',
            );
          }
          return const LocationStatusSnapshot(
            permissionState: LocationPermissionState.denied,
            errorType: LocationErrorType.permissionDenied,
            diagnosticMessage: 'Location permission is currently denied.',
          );

        case LocationPermission.deniedForever:
          _logDiagnostic('Status check: permission permanently denied.');
          return const LocationStatusSnapshot(
            permissionState: LocationPermissionState.permanentlyDenied,
            errorType: LocationErrorType.permissionPermanentlyDenied,
            diagnosticMessage: 'Location permission is permanently denied.',
          );

        case LocationPermission.unableToDetermine:
          _logDiagnostic('Status check: permission unableToDetermine.');
          return const LocationStatusSnapshot(
            permissionState: LocationPermissionState.unableToDetermine,
            errorType: LocationErrorType.unableToDetermine,
            diagnosticMessage:
                'Platform returned LocationPermission.unableToDetermine.',
          );

        case LocationPermission.whileInUse:
        case LocationPermission.always:
          _hadGrantedPermission = true;
          _denialCount = 0;

          if (requirePrecise) {
            final isPrecise = await _checkPreciseAccuracy(
              attemptTemporaryUpgrade: false,
            );
            if (!isPrecise) {
              _logDiagnostic(
                'Status check: approximate location granted instead of precise.',
              );
              return const LocationStatusSnapshot(
                permissionState: LocationPermissionState.approximateGranted,
                errorType: LocationErrorType.preciseLocationRequired,
                diagnosticMessage:
                    'Location accuracy status is reduced (approximate).',
              );
            }
          }

          return const LocationStatusSnapshot(
            permissionState: LocationPermissionState.granted,
          );
      }
    } on PermissionDefinitionsNotFoundException catch (e) {
      _logDiagnostic(
        'Status check configuration error: PermissionDefinitionsNotFoundException',
      );
      return LocationStatusSnapshot(
        permissionState: LocationPermissionState.configurationError,
        errorType: LocationErrorType.unexpected,
        diagnosticMessage: e.toString(),
      );
    } on ActivityMissingException catch (e) {
      _logDiagnostic(
        'Status check configuration error: ActivityMissingException',
      );
      return LocationStatusSnapshot(
        permissionState: LocationPermissionState.configurationError,
        errorType: LocationErrorType.unexpected,
        diagnosticMessage: e.toString(),
      );
    } catch (e) {
      _logDiagnostic('Status check unexpected error: ${e.runtimeType}');
      return LocationStatusSnapshot(
        permissionState: LocationPermissionState.error,
        errorType: LocationErrorType.unexpected,
        diagnosticMessage: 'Failed to check location status: ${e.runtimeType}',
      );
    }
  }

  /// Acquires and validates the user's current location, handling all permission,
  /// GPS service, accuracy, timeout, retry, and last-known fallback rules.
  static Future<LocationAcquireResult> acquireCurrentLocation({
    bool requestPermissionIfNeeded = true,
    bool isUserInitiated = false,
    bool requirePrecise = true,
    bool allowLastKnownFallback = true,
    double maxAcceptableAccuracyMeters = defaultMaxAcceptableAccuracyMeters,
    Duration maxLastKnownAge = defaultMaxLastKnownAge,
    Duration timeout = defaultAcquireTimeout,
    Duration permissionRequestTimeout = defaultPermissionRequestTimeout,
    int maxRetries = 1,
  }) {
    if (_inFlightAcquireRequest != null) {
      return _inFlightAcquireRequest!;
    }

    final future = _acquireCurrentLocationInternal(
      requestPermissionIfNeeded: requestPermissionIfNeeded,
      isUserInitiated: isUserInitiated,
      requirePrecise: requirePrecise,
      allowLastKnownFallback: allowLastKnownFallback,
      maxAcceptableAccuracyMeters: maxAcceptableAccuracyMeters,
      maxLastKnownAge: maxLastKnownAge,
      timeout: timeout,
      permissionRequestTimeout: permissionRequestTimeout,
      maxRetries: maxRetries,
    );
    _inFlightAcquireRequest = future;
    return future.whenComplete(() {
      if (identical(_inFlightAcquireRequest, future)) {
        _inFlightAcquireRequest = null;
      }
    });
  }

  static Future<LocationAcquireResult> _acquireCurrentLocationInternal({
    required bool requestPermissionIfNeeded,
    required bool isUserInitiated,
    required bool requirePrecise,
    required bool allowLastKnownFallback,
    required double maxAcceptableAccuracyMeters,
    required Duration maxLastKnownAge,
    required Duration timeout,
    required Duration permissionRequestTimeout,
    required int maxRetries,
  }) async {
    // 1. Check whether location services (GPS) are enabled.
    try {
      final serviceEnabled = await _gateway.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logDiagnostic('Location acquisition aborted: GPS/service disabled.');
        return LocationAcquireFailure(
          errorType: LocationErrorType.serviceDisabled,
          permissionState: LocationPermissionState.serviceDisabled,
          diagnosticMessage: 'Location services (GPS) are disabled.',
        );
      }
    } on LocationServiceDisabledException catch (e) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.serviceDisabled,
        permissionState: LocationPermissionState.serviceDisabled,
        diagnosticMessage: 'LocationServiceDisabledException during check.',
        cause: e,
      );
    } catch (e) {
      _logDiagnostic(
        'Error checking isLocationServiceEnabled: ${e.runtimeType}',
      );
      return _mapExceptionToFailure(e);
    }

    // 2. Check current permission status.
    LocationPermission permission;
    try {
      permission = await _gateway.checkPermission();
    } catch (e) {
      _logDiagnostic('Error calling checkPermission: ${e.runtimeType}');
      return _mapExceptionToFailure(e);
    }

    final wasPreviouslyGranted = _hadGrantedPermission;

    // 3. Handle non-granted permission states.
    if (permission == LocationPermission.deniedForever) {
      _logDiagnostic('Permission is permanently denied (deniedForever).');
      return LocationAcquireFailure(
        errorType: LocationErrorType.permissionPermanentlyDenied,
        permissionState: wasPreviouslyGranted
            ? LocationPermissionState.revoked
            : LocationPermissionState.permanentlyDenied,
        diagnosticMessage: 'checkPermission returned deniedForever.',
      );
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      // Never treat unableToDetermine as granted.
      if (!requestPermissionIfNeeded) {
        if (permission == LocationPermission.unableToDetermine) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.unableToDetermine,
            permissionState: LocationPermissionState.unableToDetermine,
            diagnosticMessage:
                'Permission status is unableToDetermine and prompting was disabled.',
          );
        }
        if (wasPreviouslyGranted) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.permissionDenied,
            permissionState: LocationPermissionState.revoked,
            diagnosticMessage: 'Permission was revoked in settings.',
          );
        }
        if (!_hasRequestedPermissionInSession) {
          return LocationAcquireFailure(
            errorType: LocationErrorType.permissionRequired,
            permissionState: LocationPermissionState.notRequested,
            diagnosticMessage: 'Permission has not been requested yet.',
          );
        }
        return LocationAcquireFailure(
          errorType: _denialCount >= 2
              ? LocationErrorType.permissionDeniedRepeatedly
              : LocationErrorType.permissionDenied,
          permissionState: _denialCount >= 2
              ? LocationPermissionState.deniedRepeatedly
              : LocationPermissionState.denied,
          diagnosticMessage: 'Permission was previously denied.',
        );
      }

      // If permission was revoked while running and this is not an explicit user action,
      // do not surprise the user with a system prompt automatically.
      if (wasPreviouslyGranted && !isUserInitiated) {
        _logDiagnostic(
          'Permission was revoked; skipping automatic re-prompt until user action.',
        );
        return LocationAcquireFailure(
          errorType: LocationErrorType.permissionDenied,
          permissionState: LocationPermissionState.revoked,
          diagnosticMessage:
              'Permission was revoked; awaiting explicit user action to re-request.',
        );
      }

      // Avoid endless permission-request loops on automatic loads after user has already denied.
      if (_hasRequestedPermissionInSession &&
          _denialCount > 0 &&
          !isUserInitiated) {
        _logDiagnostic(
          'Skipping automatic permission prompt because user already denied ($_denialCount times).',
        );
        return LocationAcquireFailure(
          errorType: _denialCount >= 2
              ? LocationErrorType.permissionDeniedRepeatedly
              : LocationErrorType.permissionDenied,
          permissionState: _denialCount >= 2
              ? LocationPermissionState.deniedRepeatedly
              : LocationPermissionState.denied,
          diagnosticMessage:
              'Suppressed automatic permission prompt after previous denial.',
        );
      }

      // If unableToDetermine and we already tried requesting once, do not loop.
      if (permission == LocationPermission.unableToDetermine &&
          _hasRequestedPermissionInSession &&
          !isUserInitiated) {
        return LocationAcquireFailure(
          errorType: LocationErrorType.unableToDetermine,
          permissionState: LocationPermissionState.unableToDetermine,
          diagnosticMessage:
              'Permission status remains unableToDetermine after request.',
        );
      }

      // Perform the permission request safely.
      final requestFailureOrPermission = await _requestPermissionSafely(
        timeout: permissionRequestTimeout,
      );
      if (requestFailureOrPermission.$1 != null) {
        return requestFailureOrPermission.$1!;
      }
      permission = requestFailureOrPermission.$2!;
    }

    // 4. Evaluate permission result after any prompt.
    switch (permission) {
      case LocationPermission.denied:
        _denialCount += 1;
        final isRepeated = _denialCount >= 2;
        _logDiagnostic(
          'Permission denied by user (denialCount=$_denialCount, repeated=$isRepeated).',
        );
        return LocationAcquireFailure(
          errorType: isRepeated
              ? LocationErrorType.permissionDeniedRepeatedly
              : LocationErrorType.permissionDenied,
          permissionState: isRepeated
              ? LocationPermissionState.deniedRepeatedly
              : (wasPreviouslyGranted
                    ? LocationPermissionState.revoked
                    : LocationPermissionState.denied),
          diagnosticMessage:
              'Permission denied (session denial count: $_denialCount).',
        );

      case LocationPermission.deniedForever:
        _denialCount += 1;
        _logDiagnostic('Permission permanently denied after request.');
        return LocationAcquireFailure(
          errorType: LocationErrorType.permissionPermanentlyDenied,
          permissionState: LocationPermissionState.permanentlyDenied,
          diagnosticMessage: 'requestPermission returned deniedForever.',
        );

      case LocationPermission.unableToDetermine:
        _logDiagnostic('Permission remains unableToDetermine after request.');
        return LocationAcquireFailure(
          errorType: LocationErrorType.unableToDetermine,
          permissionState: LocationPermissionState.unableToDetermine,
          diagnosticMessage: 'requestPermission returned unableToDetermine.',
        );

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        _hadGrantedPermission = true;
        _denialCount = 0;
    }

    // 5. Verify location accuracy status (Precise vs Approximate).
    if (requirePrecise) {
      final hasPreciseAccuracy = await _checkPreciseAccuracy(
        attemptTemporaryUpgrade: isUserInitiated,
      );
      if (!hasPreciseAccuracy) {
        _logDiagnostic(
          'Approximate location granted instead of required precise location.',
        );
        return LocationAcquireFailure(
          errorType: LocationErrorType.preciseLocationRequired,
          permissionState: LocationPermissionState.approximateGranted,
          diagnosticMessage:
              'Precise location is required, but device reported LocationAccuracyStatus.reduced.',
        );
      }
    }

    // 6. Acquire current position with bounded retries and validation.
    Object? lastError;
    bool hadInaccurateFix = false;
    final totalAttempts = (maxRetries < 0 ? 0 : maxRetries) + 1;

    for (var attempt = 0; attempt < totalAttempts; attempt++) {
      if (attempt > 0) {
        // Re-verify GPS and permission before retrying in case state changed mid-flight.
        final statusAfterFailure = await checkLocationStatus(
          requirePrecise: requirePrecise,
        );
        if (!statusAfterFailure.isReady &&
            statusAfterFailure.errorType != null) {
          return LocationAcquireFailure(
            errorType: statusAfterFailure.errorType!,
            permissionState: statusAfterFailure.permissionState,
            diagnosticMessage: statusAfterFailure.diagnosticMessage,
            cause: lastError,
          );
        }
      }

      try {
        final position = await _gateway.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: timeout,
          ),
        );

        if (!isValidCoordinate(position.latitude, position.longitude)) {
          _logDiagnostic(
            'Attempt ${attempt + 1}: provider returned invalid coordinates.',
          );
          lastError = const PositionUpdateException(
            'Location provider returned out-of-range or uninitialized coordinates.',
          );
          continue;
        }

        final hasMeasuredAccuracy =
            position.hasAccuracy || position.accuracy > 0;
        if (requirePrecise &&
            hasMeasuredAccuracy &&
            position.accuracy > maxAcceptableAccuracyMeters) {
          _logDiagnostic(
            'Attempt ${attempt + 1}: position accuracy (${position.accuracy.toStringAsFixed(1)}m) '
            'exceeds threshold (${maxAcceptableAccuracyMeters.toStringAsFixed(1)}m).',
          );
          hadInaccurateFix = true;
          lastError = PositionUpdateException(
            'Location accuracy ${position.accuracy.toStringAsFixed(1)}m is insufficient.',
          );
          continue;
        }

        return LocationAcquireSuccess(
          coordinates: LocationCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
            accuracyMeters: hasMeasuredAccuracy ? position.accuracy : null,
            timestamp: position.timestamp,
          ),
          permissionState: LocationPermissionState.granted,
          position: position,
        );
      } on TimeoutException catch (e) {
        _logDiagnostic(
          'Attempt ${attempt + 1} timed out after ${timeout.inSeconds}s.',
        );
        lastError = e;
      } on LocationServiceDisabledException catch (e) {
        _logDiagnostic(
          'LocationServiceDisabledException during getCurrentPosition.',
        );
        return LocationAcquireFailure(
          errorType: LocationErrorType.serviceDisabled,
          permissionState: LocationPermissionState.serviceDisabled,
          diagnosticMessage:
              'Location services were disabled while acquiring position.',
          cause: e,
        );
      } on PermissionDeniedException catch (e) {
        _logDiagnostic('PermissionDeniedException during getCurrentPosition.');
        final postErrorStatus = await checkLocationStatus(
          requirePrecise: requirePrecise,
        );
        final errorType =
            postErrorStatus.errorType ?? LocationErrorType.permissionDenied;
        final permState = postErrorStatus.isReady
            ? LocationPermissionState.denied
            : postErrorStatus.permissionState;
        return LocationAcquireFailure(
          errorType: errorType,
          permissionState: permState,
          diagnosticMessage:
              'PermissionDeniedException thrown while acquiring position.',
          cause: e,
        );
      } on PermissionDefinitionsNotFoundException catch (e) {
        _logDiagnostic(
          'PermissionDefinitionsNotFoundException during getCurrentPosition.',
        );
        return LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.configurationError,
          diagnosticMessage: e.toString(),
          cause: e,
        );
      } on ActivityMissingException catch (e) {
        _logDiagnostic('ActivityMissingException during getCurrentPosition.');
        return LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.configurationError,
          diagnosticMessage: e.toString(),
          cause: e,
        );
      } on PositionUpdateException catch (e) {
        _logDiagnostic(
          'Attempt ${attempt + 1} failed with PositionUpdateException.',
        );
        lastError = e;
      } on PlatformException catch (e) {
        _logDiagnostic(
          'Attempt ${attempt + 1} failed with PlatformException(${e.code}).',
        );
        final mapped = _tryMapPlatformExceptionCode(e);
        if (mapped != null) {
          return mapped;
        }
        lastError = e;
      } catch (e) {
        _logDiagnostic(
          'Attempt ${attempt + 1} failed with unexpected ${e.runtimeType}.',
        );
        lastError = e;
        break;
      }
    }

    // 7. Re-verify service & permission state before considering fallback.
    final statusBeforeFallback = await checkLocationStatus(
      requirePrecise: requirePrecise,
    );
    if (!statusBeforeFallback.isReady &&
        statusBeforeFallback.errorType != null) {
      return LocationAcquireFailure(
        errorType: statusBeforeFallback.errorType!,
        permissionState: statusBeforeFallback.permissionState,
        diagnosticMessage: statusBeforeFallback.diagnosticMessage,
        cause: lastError,
      );
    }

    if (hadInaccurateFix) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.preciseLocationRequired,
        permissionState: LocationPermissionState.approximateGranted,
        diagnosticMessage:
            'Acquired position did not meet accuracy threshold (${maxAcceptableAccuracyMeters}m).',
        cause: lastError,
      );
    }

    // 8. Consider last-known position ONLY when allowed and only if fresh and accurate.
    if (allowLastKnownFallback &&
        (lastError is TimeoutException ||
            lastError is PositionUpdateException ||
            lastError is PlatformException)) {
      final fallbackPosition = await _tryGetValidatedLastKnownPosition(
        requirePrecise: requirePrecise,
        maxAcceptableAccuracyMeters: maxAcceptableAccuracyMeters,
        maxLastKnownAge: maxLastKnownAge,
      );
      if (fallbackPosition != null) {
        final hasMeasuredAccuracy =
            fallbackPosition.hasAccuracy || fallbackPosition.accuracy > 0;
        return LocationAcquireSuccess(
          coordinates: LocationCoordinates(
            latitude: fallbackPosition.latitude,
            longitude: fallbackPosition.longitude,
            accuracyMeters: hasMeasuredAccuracy
                ? fallbackPosition.accuracy
                : null,
            timestamp: fallbackPosition.timestamp,
            isFromLastKnown: true,
          ),
          permissionState: LocationPermissionState.granted,
          position: fallbackPosition,
        );
      }
    }

    // 9. Map final acquisition error without confusing GPS/provider failures with permission errors.
    if (lastError is TimeoutException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.timeout,
        permissionState: LocationPermissionState.granted,
        diagnosticMessage:
            'Location request timed out after $totalAttempts attempt(s).',
        cause: lastError,
      );
    }

    if (lastError is PositionUpdateException ||
        lastError is PlatformException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.temporarilyUnavailable,
        permissionState: LocationPermissionState.granted,
        diagnosticMessage:
            'Device location is temporarily unavailable (${lastError.runtimeType}).',
        cause: lastError,
      );
    }

    return LocationAcquireFailure(
      errorType: LocationErrorType.unexpected,
      permissionState: LocationPermissionState.granted,
      diagnosticMessage:
          'Unexpected location acquisition error (${lastError.runtimeType}).',
      cause: lastError,
    );
  }

  /// Backward-compatible helper that returns [Position] on success or `null` on failure.
  /// Prefer [acquireCurrentLocation] for rich error and permission state handling.
  static Future<Position?> getCurrentPosition() async {
    final result = await acquireCurrentLocation();
    return switch (result) {
      LocationAcquireSuccess(:final position, :final coordinates) =>
        position ??
            Position(
              latitude: coordinates.latitude,
              longitude: coordinates.longitude,
              timestamp: coordinates.timestamp ?? _gateway.now(),
              accuracy: coordinates.accuracyMeters ?? 0.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              hasAccuracy: coordinates.accuracyMeters != null,
            ),
      LocationAcquireFailure() => null,
    };
  }

  static Future<(LocationAcquireFailure?, LocationPermission?)>
  _requestPermissionSafely({required Duration timeout}) async {
    _hasRequestedPermissionInSession = true;

    try {
      final Future<LocationPermission> requestFuture;
      if (_inFlightPermissionRequest != null) {
        requestFuture = _inFlightPermissionRequest!;
      } else {
        requestFuture = _gateway.requestPermission();
        _inFlightPermissionRequest = requestFuture;
      }

      final permission = await requestFuture.timeout(timeout);
      return (null, permission);
    } on TimeoutException catch (e) {
      _logDiagnostic(
        'Permission request timed out or was dismissed by user without callback.',
      );
      // Re-check permission in case the user granted/denied right as timeout fired.
      try {
        final current = await _gateway.checkPermission();
        if (current == LocationPermission.whileInUse ||
            current == LocationPermission.always) {
          return (null, current);
        }
        if (current == LocationPermission.deniedForever) {
          return (
            LocationAcquireFailure(
              errorType: LocationErrorType.permissionPermanentlyDenied,
              permissionState: LocationPermissionState.permanentlyDenied,
              diagnosticMessage:
                  'Permission is deniedForever after prompt timeout.',
              cause: e,
            ),
            null,
          );
        }
      } catch (_) {}

      return (
        LocationAcquireFailure(
          errorType: LocationErrorType.permissionDenied,
          permissionState: LocationPermissionState.requestCancelled,
          diagnosticMessage:
              'Permission prompt was dismissed or cancelled before completion.',
          cause: e,
        ),
        null,
      );
    } on PermissionRequestInProgressException catch (e) {
      _logDiagnostic('PermissionRequestInProgressException encountered.');
      try {
        final current = await _gateway.checkPermission();
        if (current == LocationPermission.whileInUse ||
            current == LocationPermission.always) {
          return (null, current);
        }
      } catch (_) {}
      return (
        LocationAcquireFailure(
          errorType: LocationErrorType.temporarilyUnavailable,
          permissionState: LocationPermissionState.requestCancelled,
          diagnosticMessage: 'A permission request is already in progress.',
          cause: e,
        ),
        null,
      );
    } on PermissionDefinitionsNotFoundException catch (e) {
      _logDiagnostic(
        'PermissionDefinitionsNotFoundException during requestPermission.',
      );
      return (
        LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.configurationError,
          diagnosticMessage: e.toString(),
          cause: e,
        ),
        null,
      );
    } on ActivityMissingException catch (e) {
      _logDiagnostic('ActivityMissingException during requestPermission.');
      return (
        LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.configurationError,
          diagnosticMessage: e.toString(),
          cause: e,
        ),
        null,
      );
    } on PermissionDeniedException catch (e) {
      _denialCount += 1;
      return (
        LocationAcquireFailure(
          errorType: _denialCount >= 2
              ? LocationErrorType.permissionDeniedRepeatedly
              : LocationErrorType.permissionDenied,
          permissionState: _denialCount >= 2
              ? LocationPermissionState.deniedRepeatedly
              : LocationPermissionState.denied,
          diagnosticMessage: 'PermissionDeniedException thrown on request.',
          cause: e,
        ),
        null,
      );
    } on PlatformException catch (e) {
      _logDiagnostic('PlatformException(${e.code}) during requestPermission.');
      final mapped = _tryMapPlatformExceptionCode(e);
      if (mapped != null) {
        return (mapped, null);
      }
      if (e.code.toUpperCase().contains('CANCEL')) {
        return (
          LocationAcquireFailure(
            errorType: LocationErrorType.permissionDenied,
            permissionState: LocationPermissionState.requestCancelled,
            diagnosticMessage: 'Permission request cancelled (${e.code}).',
            cause: e,
          ),
          null,
        );
      }
      return (
        LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.error,
          diagnosticMessage: 'PlatformException(${e.code}) during request.',
          cause: e,
        ),
        null,
      );
    } catch (e) {
      _logDiagnostic(
        'Unexpected error during requestPermission: ${e.runtimeType}',
      );
      return (_mapExceptionToFailure(e), null);
    } finally {
      _inFlightPermissionRequest = null;
    }
  }

  static Future<bool> _checkPreciseAccuracy({
    required bool attemptTemporaryUpgrade,
  }) async {
    try {
      var accuracy = await _gateway.getLocationAccuracy();
      if (accuracy == LocationAccuracyStatus.reduced &&
          attemptTemporaryUpgrade &&
          _gateway.targetPlatform == TargetPlatform.iOS) {
        try {
          accuracy = await _gateway.requestTemporaryFullAccuracy(
            purposeKey: temporaryAccuracyPurposeKey,
          );
        } catch (e) {
          _logDiagnostic(
            'Unable to request temporary full accuracy on iOS: ${e.runtimeType}',
          );
        }
      }
      // LocationAccuracyStatus.precise or LocationAccuracyStatus.unknown
      // (returned on platforms/SDKs that do not expose coarse vs fine status)
      // are accepted; only explicit reduced accuracy is rejected here.
      return accuracy != LocationAccuracyStatus.reduced;
    } on UnsupportedError {
      return true;
    } on MissingPluginException {
      return true;
    } catch (e) {
      _logDiagnostic('getLocationAccuracy check failed: ${e.runtimeType}');
      return true;
    }
  }

  static Future<Position?> _tryGetValidatedLastKnownPosition({
    required bool requirePrecise,
    required double maxAcceptableAccuracyMeters,
    required Duration maxLastKnownAge,
  }) async {
    try {
      final lastKnown = await _gateway.getLastKnownPosition();
      if (lastKnown == null) {
        _logDiagnostic('No last-known position available.');
        return null;
      }

      if (!isValidCoordinate(lastKnown.latitude, lastKnown.longitude)) {
        _logDiagnostic('Rejected last-known position: invalid coordinates.');
        return null;
      }

      final age = _gateway.now().difference(lastKnown.timestamp).abs();
      if (age > maxLastKnownAge) {
        _logDiagnostic(
          'Rejected stale last-known position (age: ${age.inSeconds}s > ${maxLastKnownAge.inSeconds}s).',
        );
        return null;
      }

      final hasMeasuredAccuracy =
          lastKnown.hasAccuracy || lastKnown.accuracy > 0;
      if (requirePrecise) {
        if (!hasMeasuredAccuracy ||
            lastKnown.accuracy > maxAcceptableAccuracyMeters) {
          _logDiagnostic(
            'Rejected inaccurate last-known position '
            '(hasAccuracy=$hasMeasuredAccuracy, accuracy=${lastKnown.accuracy.toStringAsFixed(1)}m).',
          );
          return null;
        }
      }

      _logDiagnostic(
        'Using validated last-known position (age: ${age.inSeconds}s, '
        'accuracy: ${lastKnown.accuracy.toStringAsFixed(1)}m).',
      );
      return lastKnown;
    } catch (e) {
      _logDiagnostic('Failed to read last-known position: ${e.runtimeType}');
      return null;
    }
  }

  static LocationAcquireFailure? _tryMapPlatformExceptionCode(
    PlatformException e,
  ) {
    switch (e.code) {
      case 'LOCATION_SERVICES_DISABLED':
        return LocationAcquireFailure(
          errorType: LocationErrorType.serviceDisabled,
          permissionState: LocationPermissionState.serviceDisabled,
          diagnosticMessage: 'PlatformException(LOCATION_SERVICES_DISABLED)',
          cause: e,
        );
      case 'PERMISSION_DENIED':
        _denialCount += 1;
        return LocationAcquireFailure(
          errorType: _denialCount >= 2
              ? LocationErrorType.permissionDeniedRepeatedly
              : LocationErrorType.permissionDenied,
          permissionState: _denialCount >= 2
              ? LocationPermissionState.deniedRepeatedly
              : LocationPermissionState.denied,
          diagnosticMessage: 'PlatformException(PERMISSION_DENIED)',
          cause: e,
        );
      case 'PERMISSION_DEFINITIONS_NOT_FOUND':
      case 'ACTIVITY_MISSING':
        return LocationAcquireFailure(
          errorType: LocationErrorType.unexpected,
          permissionState: LocationPermissionState.configurationError,
          diagnosticMessage: 'PlatformException(${e.code})',
          cause: e,
        );
      case 'PERMISSION_REQUEST_IN_PROGRESS':
        return LocationAcquireFailure(
          errorType: LocationErrorType.temporarilyUnavailable,
          permissionState: LocationPermissionState.requestCancelled,
          diagnosticMessage:
              'PlatformException(PERMISSION_REQUEST_IN_PROGRESS)',
          cause: e,
        );
      case 'LOCATION_UPDATE_FAILURE':
        return LocationAcquireFailure(
          errorType: LocationErrorType.temporarilyUnavailable,
          permissionState: LocationPermissionState.granted,
          diagnosticMessage: 'PlatformException(LOCATION_UPDATE_FAILURE)',
          cause: e,
        );
      default:
        return null;
    }
  }

  static LocationAcquireFailure _mapExceptionToFailure(Object error) {
    if (error is LocationServiceDisabledException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.serviceDisabled,
        permissionState: LocationPermissionState.serviceDisabled,
        diagnosticMessage: 'LocationServiceDisabledException',
        cause: error,
      );
    }
    if (error is PermissionDeniedException) {
      _denialCount += 1;
      return LocationAcquireFailure(
        errorType: _denialCount >= 2
            ? LocationErrorType.permissionDeniedRepeatedly
            : LocationErrorType.permissionDenied,
        permissionState: _denialCount >= 2
            ? LocationPermissionState.deniedRepeatedly
            : LocationPermissionState.denied,
        diagnosticMessage: 'PermissionDeniedException',
        cause: error,
      );
    }
    if (error is PermissionDefinitionsNotFoundException ||
        error is ActivityMissingException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.unexpected,
        permissionState: LocationPermissionState.configurationError,
        diagnosticMessage: error.runtimeType.toString(),
        cause: error,
      );
    }
    if (error is PermissionRequestInProgressException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.temporarilyUnavailable,
        permissionState: LocationPermissionState.requestCancelled,
        diagnosticMessage: 'PermissionRequestInProgressException',
        cause: error,
      );
    }
    if (error is TimeoutException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.timeout,
        permissionState: LocationPermissionState.granted,
        diagnosticMessage: 'TimeoutException',
        cause: error,
      );
    }
    if (error is PositionUpdateException) {
      return LocationAcquireFailure(
        errorType: LocationErrorType.temporarilyUnavailable,
        permissionState: LocationPermissionState.granted,
        diagnosticMessage: 'PositionUpdateException',
        cause: error,
      );
    }
    if (error is PlatformException) {
      final mapped = _tryMapPlatformExceptionCode(error);
      if (mapped != null) return mapped;
    }
    return LocationAcquireFailure(
      errorType: LocationErrorType.unexpected,
      permissionState: LocationPermissionState.error,
      diagnosticMessage: 'Unhandled exception: ${error.runtimeType}',
      cause: error,
    );
  }

  static void _logDiagnostic(String message) {
    debugPrint('[LocationHelper] $message');
  }
}
