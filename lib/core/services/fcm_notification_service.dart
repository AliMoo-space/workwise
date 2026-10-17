import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/routing/router_generation_config.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/notification/domain/usecases/notification_actions.dart';
import 'package:workwise/firebase_options.dart';

typedef FirebaseBackgroundInitializer = Future<void> Function();
typedef LocalNotificationTapCallback =
    Future<void> Function(
      Map<String, dynamic> data, {
      required bool isInitialLaunch,
    });

/// Abstraction for initializing local notification channels and displaying
/// system notifications when FCM messages arrive in the foreground (or as
/// data-only messages in the background).
abstract class FcmLocalNotificationPresenter {
  Future<void> initialize({LocalNotificationTapCallback? onNotificationTapped});

  Future<void> showNotification(FcmParsedNotification notification);
}

/// Default [MethodChannel]-backed implementation that delegates Android channel
/// creation, heads-up local notification presentation, and tap callbacks to the
/// host platform (`com.alimohamed.workwise/local_notifications`).
class MethodChannelFcmLocalNotificationPresenter
    implements FcmLocalNotificationPresenter {
  const MethodChannelFcmLocalNotificationPresenter({MethodChannel? channel})
    : _channel = channel ?? _defaultChannel;

  static const MethodChannel _defaultChannel = MethodChannel(
    FcmNotificationService.localNotificationMethodChannelName,
  );

  final MethodChannel _channel;

  @override
  Future<void> initialize({
    LocalNotificationTapCallback? onNotificationTapped,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationTapped' &&
          onNotificationTapped != null) {
        final data = _decodePayload(call.arguments);
        await onNotificationTapped(data, isInitialLaunch: false);
      }
    });

    try {
      final initialPayload = await _channel.invokeMethod<Object?>(
        'initialize',
        <String, Object?>{
          'channelId': FcmNotificationService.androidNotificationChannelId,
          'channelName': FcmNotificationService.androidNotificationChannelName,
          'channelDescription':
              FcmNotificationService.androidNotificationChannelDescription,
        },
      );

      if (initialPayload != null && onNotificationTapped != null) {
        final data = _decodePayload(initialPayload);
        if (data.isNotEmpty) {
          await onNotificationTapped(data, isInitialLaunch: true);
        }
      }
    } on MissingPluginException {
      // Safe no-op in unit test environments or platforms without native handler.
    } on PlatformException catch (e) {
      debugPrint(
        'Local notification channel initialization warning: ${e.code}',
      );
    }
  }

  @override
  Future<void> showNotification(FcmParsedNotification notification) async {
    if (!notification.hasVisibleContent) return;

    final keySeed =
        notification.deduplicationKey ??
        notification.notificationId ??
        '${notification.title ?? ''}|${notification.body ?? ''}';
    final notificationId = keySeed.hashCode & 0x7fffffff;

    final payloadMap = <String, dynamic>{
      ...notification.data,
      if (notification.deduplicationKey != null)
        '_deduplication_key': notification.deduplicationKey,
      if (notification.notificationId != null)
        'notification_id': notification.notificationId,
      if (notification.type != null) 'type': notification.type,
    };

    try {
      await _channel.invokeMethod<void>('showNotification', <String, Object?>{
        'id': notificationId,
        'title': notification.title ?? 'WorkWise',
        'body': notification.body ?? '',
        'channelId': FcmNotificationService.androidNotificationChannelId,
        'channelName': FcmNotificationService.androidNotificationChannelName,
        'channelDescription':
            FcmNotificationService.androidNotificationChannelDescription,
        'deduplicationKey': notification.deduplicationKey,
        'payload': jsonEncode(payloadMap),
      });
    } on MissingPluginException {
      // Safe no-op in unit test environments or headless isolates where native
      // WorkWiseFcmDataReceiver handles background data-only display.
    } on PlatformException catch (e) {
      debugPrint('Local notification display warning: ${e.code}');
    }
  }

  static Map<String, dynamic> _decodePayload(Object? raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return const {};
      }
    }
    return const {};
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message, {
  FirebaseBackgroundInitializer? firebaseInitializer,
  FcmLocalNotificationPresenter? localNotificationPresenter,
  TargetPlatform? platformOverride,
}) async {
  try {
    if (firebaseInitializer != null) {
      await firebaseInitializer();
    } else if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('FCM background initialization warning: ${e.runtimeType}');
  }

  try {
    final parsed = FcmNotificationService.parseRemoteMessage(
      message,
      platform: platformOverride ?? defaultTargetPlatform,
      isForeground: false,
    );
    if (parsed.shouldDisplayLocalNotification) {
      final presenter =
          localNotificationPresenter ??
          const MethodChannelFcmLocalNotificationPresenter();
      await presenter.showNotification(parsed);
    }
  } catch (e) {
    debugPrint('FCM background notification warning: ${e.runtimeType}');
  }
}

/// Parsed, sanitized representation of an incoming FCM [RemoteMessage].
final class FcmParsedNotification extends Equatable {
  const FcmParsedNotification({
    required this.deduplicationKey,
    required this.notificationId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.hasSystemNotificationBlock,
    required this.shouldDisplayInAppBanner,
    required this.targetRoute,
    bool? shouldDisplayLocalNotification,
  }) : shouldDisplayLocalNotification =
           shouldDisplayLocalNotification ?? shouldDisplayInAppBanner;

  final String? deduplicationKey;
  final String? notificationId;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  /// True when the FCM message contains a non-empty `notification` block
  /// (`RemoteMessage.notification`) that the OS can present directly in
  /// background/terminated states (and on iOS in foreground).
  final bool hasSystemNotificationBlock;

  /// True when the app should present a foreground notification banner.
  /// On iOS, when [hasSystemNotificationBlock] is true, iOS already presents
  /// the system alert via `setForegroundNotificationPresentationOptions`, so
  /// this is false to prevent duplicate display.
  final bool shouldDisplayInAppBanner;

  /// True when the app should display a local system notification for this
  /// message:
  /// - In foreground on Android: true whenever [hasVisibleContent] is true
  ///   (both `notification` and `data`-only payloads).
  /// - In foreground on iOS: true only for `data`-only messages with visible
  ///   content (`!hasSystemNotificationBlock && hasVisibleContent`).
  /// - In background/terminated: true only for `data`-only messages with
  ///   visible content (`!hasSystemNotificationBlock && hasVisibleContent`),
  ///   because the OS already displays messages with a `notification` block.
  final bool shouldDisplayLocalNotification;

  /// Validated internal GoRouter route to navigate to when tapped.
  final String targetRoute;

  bool get hasVisibleContent =>
      (title != null && title!.isNotEmpty) ||
      (body != null && body!.isNotEmpty);

  @override
  List<Object?> get props => [
    deduplicationKey,
    notificationId,
    type,
    title,
    body,
    data,
    hasSystemNotificationBlock,
    shouldDisplayInAppBanner,
    shouldDisplayLocalNotification,
    targetRoute,
  ];
}

typedef FcmTokenProvider = Future<String?> Function();
typedef FcmApnsTokenProvider = Future<String?> Function();
typedef FcmTokenDeleter = Future<void> Function();
typedef FcmTokenRefreshStreamProvider = Stream<String> Function();
typedef FcmRemoteMessageStreamProvider = Stream<RemoteMessage> Function();
typedef FcmInitialMessageProvider = Future<RemoteMessage?> Function();
typedef FcmPermissionRequester = Future<AuthorizationStatus> Function();
typedef FcmForegroundOptionsSetter = Future<void> Function();
typedef FcmNavigationCallback = void Function(String route);

class FcmNotificationService {
  FcmNotificationService({
    required this.updateFcmToken,
    required this.secureStorage,
    required this.localStorage,
    this.apiConsumer,
    FcmLocalNotificationPresenter? localNotificationPresenter,
    FcmTokenProvider? tokenProvider,
    FcmApnsTokenProvider? apnsTokenProvider,
    FcmTokenDeleter? tokenDeleter,
    FcmTokenRefreshStreamProvider? tokenRefreshStreamProvider,
    FcmRemoteMessageStreamProvider? foregroundMessageStreamProvider,
    FcmRemoteMessageStreamProvider? messageOpenedAppStreamProvider,
    FcmInitialMessageProvider? initialMessageProvider,
    FcmPermissionRequester? permissionRequester,
    FcmForegroundOptionsSetter? foregroundOptionsSetter,
    FcmNavigationCallback? onNavigate,
    this.platformOverride,
    this.requiresApnsCheckOverride,
    this.maxApnsRetries = 3,
    this.apnsRetryDelay = const Duration(milliseconds: 400),
  }) : _localNotificationPresenter =
           localNotificationPresenter ??
           const MethodChannelFcmLocalNotificationPresenter(),
       _tokenProvider =
           tokenProvider ?? (() => FirebaseMessaging.instance.getToken()),
       _apnsTokenProvider =
           apnsTokenProvider ??
           (() => FirebaseMessaging.instance.getAPNSToken()),
       _tokenDeleter =
           tokenDeleter ?? (() => FirebaseMessaging.instance.deleteToken()),
       _tokenRefreshStreamProvider =
           tokenRefreshStreamProvider ??
           (() => FirebaseMessaging.instance.onTokenRefresh),
       _foregroundMessageStreamProvider =
           foregroundMessageStreamProvider ??
           (() => FirebaseMessaging.onMessage),
       _messageOpenedAppStreamProvider =
           messageOpenedAppStreamProvider ??
           (() => FirebaseMessaging.onMessageOpenedApp),
       _initialMessageProvider =
           initialMessageProvider ??
           (() => FirebaseMessaging.instance.getInitialMessage()),
       _permissionRequester =
           permissionRequester ??
           (() async {
             final settings = await FirebaseMessaging.instance
                 .requestPermission(alert: true, badge: true, sound: true);
             return settings.authorizationStatus;
           }),
       _foregroundOptionsSetter =
           foregroundOptionsSetter ??
           (() => FirebaseMessaging.instance
               .setForegroundNotificationPresentationOptions(
                 alert: true,
                 badge: true,
                 sound: true,
               )),
       _onNavigate =
           onNavigate ??
           ((route) => RouterGenerationConfig.goRouter.push(route));

  static const String localNotificationMethodChannelName =
      'com.alimohamed.workwise/local_notifications';
  static const String androidNotificationChannelId =
      'workwise_high_importance_channel';
  static const String androidNotificationChannelName = 'WorkWise Notifications';
  static const String androidNotificationChannelDescription =
      'High importance notifications for WorkWise';

  static const Set<String> _allowedStaticRoutes = {
    AppRoutes.notificationScreen,
    AppRoutes.tasksScreen,
    AppRoutes.leaveScreen,
    AppRoutes.attendanceScreen,
    AppRoutes.performanceScreen,
    AppRoutes.goalViewAll,
  };

  final UpdateFcmToken updateFcmToken;
  final SecureStorage secureStorage;
  final LocalStorage localStorage;
  final ApiConsumer? apiConsumer;
  final TargetPlatform? platformOverride;
  final bool? requiresApnsCheckOverride;
  final int maxApnsRetries;
  final Duration apnsRetryDelay;

  final FcmLocalNotificationPresenter _localNotificationPresenter;
  final FcmTokenProvider _tokenProvider;
  final FcmApnsTokenProvider _apnsTokenProvider;
  final FcmTokenDeleter _tokenDeleter;
  final FcmTokenRefreshStreamProvider _tokenRefreshStreamProvider;
  final FcmRemoteMessageStreamProvider _foregroundMessageStreamProvider;
  final FcmRemoteMessageStreamProvider _messageOpenedAppStreamProvider;
  final FcmInitialMessageProvider _initialMessageProvider;
  final FcmPermissionRequester _permissionRequester;
  final FcmForegroundOptionsSetter _foregroundOptionsSetter;
  final FcmNavigationCallback _onNavigate;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;

  final StreamController<void> _foregroundNotificationController =
      StreamController<void>.broadcast();
  final StreamController<FcmParsedNotification> _foregroundParsedController =
      StreamController<FcmParsedNotification>.broadcast();

  final Set<String> _processedForegroundKeys = <String>{};
  final Set<String> _processedTapKeys = <String>{};

  String? _lastSyncedFcmToken;
  String? _lastSyncedAccessToken;
  String? _pendingTapRoute;
  AuthorizationStatus? _lastAuthorizationStatus;
  bool? _lastApnsTokenAvailable;
  bool _initialized = false;
  bool _permissionRequested = false;
  bool _isSessionReady = false;
  bool _isLoggingOut = false;
  bool _hasExplicitlyLoggedOut = false;
  int _sessionEpoch = 0;

  /// Broadcast stream that emits whenever a foreground push notification arrives
  /// for an authenticated session, triggering a silent notification refresh.
  Stream<void> get onForegroundNotification =>
      _foregroundNotificationController.stream;

  /// Broadcast stream of parsed foreground notifications.
  Stream<FcmParsedNotification> get onForegroundMessage =>
      _foregroundParsedController.stream;

  AuthorizationStatus? get lastAuthorizationStatus => _lastAuthorizationStatus;

  /// Whether the most recent APNs readiness check succeeded (`true` on Android
  /// or when `getAPNSToken()` returned a non-empty token on iOS; `false` when
  /// APNs token remained unavailable after bounded retries).
  bool? get lastApnsTokenAvailable => _lastApnsTokenAvailable;

  TargetPlatform get _currentPlatform =>
      platformOverride ?? defaultTargetPlatform;

  bool get _requiresApnsCheck =>
      requiresApnsCheckOverride ??
      (!kIsWeb && _currentPlatform == TargetPlatform.iOS);

  /// Parses a [RemoteMessage] safely across all FCM payload formats:
  /// - `notification`-only payload (`RemoteMessage.notification`)
  /// - `data`-only payload (`data['title']`/`data['body']`/`data['message']`
  ///   or nested JSON in `data['data']` / `data['notification']`)
  /// - combined `notification` + `data` payload
  static FcmParsedNotification parseRemoteMessage(
    RemoteMessage message, {
    required TargetPlatform platform,
    required bool isForeground,
  }) {
    final rawData = Map<String, dynamic>.from(message.data);
    final nestedData = _extractNestedMap(rawData['data']);
    final nestedNotification = _extractNestedMap(rawData['notification']);

    final notificationTitle = _nonEmptyString(message.notification?.title);
    final notificationBody = _nonEmptyString(message.notification?.body);
    final hasSystemNotificationBlock =
        notificationTitle != null || notificationBody != null;

    final title =
        notificationTitle ??
        _nonEmptyString(rawData['title']) ??
        _nonEmptyString(nestedData['title']) ??
        _nonEmptyString(nestedNotification['title']);
    final body =
        notificationBody ??
        _nonEmptyString(rawData['body']) ??
        _nonEmptyString(nestedData['body']) ??
        _nonEmptyString(nestedNotification['body']) ??
        _nonEmptyString(rawData['message']) ??
        _nonEmptyString(nestedData['message']);
    final notificationId =
        _nonEmptyString(rawData['notification_id']) ??
        _nonEmptyString(rawData['id']) ??
        _nonEmptyString(nestedData['notification_id']) ??
        _nonEmptyString(nestedData['id']);
    final type =
        _nonEmptyString(rawData['type']) ?? _nonEmptyString(nestedData['type']);

    final hasVisibleContent = title != null || body != null;

    final bool shouldDisplayInAppBanner;
    final bool shouldDisplayLocalNotification;
    if (!isForeground) {
      shouldDisplayInAppBanner = false;
      // In background/terminated states, the OS already displays messages that
      // have a `notification` block; only display a local notification for
      // data-only messages with visible content to prevent duplicates.
      shouldDisplayLocalNotification =
          !hasSystemNotificationBlock && hasVisibleContent;
    } else if (platform == TargetPlatform.iOS) {
      // On iOS, `setForegroundNotificationPresentationOptions` already displays
      // messages with a `RemoteMessage.notification` block; only display a
      // local notification for data-only foreground messages.
      shouldDisplayInAppBanner =
          !hasSystemNotificationBlock && hasVisibleContent;
      shouldDisplayLocalNotification = shouldDisplayInAppBanner;
    } else {
      // On Android, FCM never auto-displays notifications while the app is in
      // the foreground, so both `notification` and `data`-only messages with
      // visible content must be displayed via local notifications.
      shouldDisplayInAppBanner = hasVisibleContent;
      shouldDisplayLocalNotification = hasVisibleContent;
    }

    final mergedData = <String, dynamic>{
      ...nestedNotification,
      ...nestedData,
      ...rawData,
    };
    final targetRoute = resolveTargetRoute(mergedData);

    final messageId = _nonEmptyString(message.messageId);
    final deduplicationKey =
        messageId ??
        notificationId ??
        (hasVisibleContent || type != null
            ? '${type ?? ''}|${title ?? ''}|${body ?? ''}|${message.sentTime?.millisecondsSinceEpoch ?? ''}'
            : null);

    return FcmParsedNotification(
      deduplicationKey: deduplicationKey,
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      data: mergedData,
      hasSystemNotificationBlock: hasSystemNotificationBlock,
      shouldDisplayInAppBanner: shouldDisplayInAppBanner,
      shouldDisplayLocalNotification: shouldDisplayLocalNotification,
      targetRoute: targetRoute,
    );
  }

  /// Resolves a validated internal route from notification payload data.
  /// Never constructs arbitrary routes from untrusted strings.
  static String resolveTargetRoute(Map<String, dynamic> data) {
    final explicitRoute =
        _nonEmptyString(data['route']) ??
        _nonEmptyString(data['screen']) ??
        _nonEmptyString(data['target']);
    final type = (_nonEmptyString(data['type']) ?? '').toLowerCase();

    final rawGoalId = data['goal_id'] ?? data['goalId'];
    final goalId = switch (rawGoalId) {
      int value when value > 0 => value,
      String value => () {
        final parsed = int.tryParse(value.trim());
        return (parsed != null && parsed > 0) ? parsed : null;
      }(),
      _ => null,
    };

    if (goalId != null &&
        (explicitRoute == AppRoutes.goalDetailsScreen ||
            type.contains('goal'))) {
      return '${AppRoutes.goalDetailsScreen}/$goalId';
    }

    if (explicitRoute != null && _allowedStaticRoutes.contains(explicitRoute)) {
      return explicitRoute;
    }

    return AppRoutes.notificationScreen;
  }

  static Map<String, dynamic> _extractNestedMap(Object? raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String && raw.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return const {};
      }
    }
    return const {};
  }

  static String? _nonEmptyString(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Initializes local notification channels, FCM permissions,
  /// foreground/background listeners, and token refresh handling.
  /// Safe to call multiple times (idempotent).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _localNotificationPresenter.initialize(
        onNotificationTapped: _handleLocalNotificationPayloadTap,
      );
    } catch (e) {
      debugPrint('Local notification initialization warning: ${e.runtimeType}');
    }

    await requestNotificationPermissionOnce();

    try {
      await _foregroundOptionsSetter();
    } catch (e) {
      debugPrint(
        'FCM foreground presentation options warning: ${e.runtimeType}',
      );
    }

    await _foregroundMessageSubscription?.cancel();
    try {
      _foregroundMessageSubscription = _foregroundMessageStreamProvider()
          .listen(
            _handleForegroundMessage,
            onError: (Object error) {
              debugPrint('FCM foreground stream error: ${error.runtimeType}');
            },
          );
    } catch (e) {
      debugPrint(
        'Failed to subscribe to FCM foreground stream: ${e.runtimeType}',
      );
    }

    await _messageOpenedAppSubscription?.cancel();
    try {
      _messageOpenedAppSubscription = _messageOpenedAppStreamProvider().listen(
        (message) => _handleNotificationTap(message, isInitialLaunch: false),
        onError: (Object error) {
          debugPrint('FCM opened-app stream error: ${error.runtimeType}');
        },
      );
    } catch (e) {
      debugPrint(
        'Failed to subscribe to FCM opened-app stream: ${e.runtimeType}',
      );
    }

    try {
      final initialMessage = await _initialMessageProvider();
      if (initialMessage != null) {
        await _handleNotificationTap(initialMessage, isInitialLaunch: true);
      }
    } catch (e) {
      debugPrint('FCM getInitialMessage warning: ${e.runtimeType}');
    }

    _listenToTokenRefresh();
  }

  /// Requests notification permission at most once per app lifecycle unless
  /// the previous attempt remained undetermined.
  Future<AuthorizationStatus?> requestNotificationPermissionOnce() async {
    if (_permissionRequested &&
        _lastAuthorizationStatus != null &&
        _lastAuthorizationStatus != AuthorizationStatus.notDetermined) {
      return _lastAuthorizationStatus;
    }
    _permissionRequested = true;
    try {
      final status = await _permissionRequester();
      _lastAuthorizationStatus = status;
      if (status != AuthorizationStatus.authorized &&
          status != AuthorizationStatus.provisional) {
        debugPrint(
          'FCM notification permission status: ${status.name} '
          '(remote notifications may be suppressed by OS settings).',
        );
      }
    } catch (e) {
      debugPrint('FCM permission request warning: ${e.runtimeType}');
    }
    return _lastAuthorizationStatus;
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription?.cancel();
    try {
      _tokenRefreshSubscription = _tokenRefreshStreamProvider().listen(
        (newToken) async {
          await _registerTokenIfAuthenticated(
            newToken,
            expectedEpoch: _sessionEpoch,
          );
        },
        onError: (Object error) {
          debugPrint('FCM token refresh error: ${error.runtimeType}');
        },
      );
    } catch (e) {
      debugPrint('Failed to subscribe to FCM token refresh: ${e.runtimeType}');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (_isLoggingOut) return;

    final parsed = parseRemoteMessage(
      message,
      platform: _currentPlatform,
      isForeground: true,
    );

    final accessToken = (await secureStorage.getAccessToken())?.trim();
    final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
    if (_isLoggingOut || (_hasExplicitlyLoggedOut && !hasAccessToken)) {
      return;
    }
    if (hasAccessToken) {
      _hasExplicitlyLoggedOut = false;
    }

    final dedupKey = parsed.deduplicationKey;
    if (dedupKey != null) {
      if (_processedForegroundKeys.contains(dedupKey)) {
        return;
      }
      _rememberBoundedKey(_processedForegroundKeys, dedupKey);
    }

    if (parsed.shouldDisplayLocalNotification) {
      try {
        await _localNotificationPresenter.showNotification(parsed);
      } catch (e) {
        debugPrint(
          'FCM foreground local notification warning: ${e.runtimeType}',
        );
      }
    }

    if (!_foregroundParsedController.isClosed) {
      _foregroundParsedController.add(parsed);
    }
    if (hasAccessToken && !_foregroundNotificationController.isClosed) {
      _foregroundNotificationController.add(null);
    }
  }

  /// Marks the authenticated session as ready, registers the device's FCM token
  /// with the backend (checking APNs availability on iOS with bounded retries),
  /// and consumes any pending cold-start or pre-login notification tap.
  Future<void> syncTokenIfAuthenticated() async {
    if (_isLoggingOut) return;
    final startEpoch = _sessionEpoch;

    final accessToken = (await secureStorage.getAccessToken())?.trim();
    if (accessToken == null ||
        accessToken.isEmpty ||
        _isLoggingOut ||
        startEpoch != _sessionEpoch) {
      return;
    }

    _hasExplicitlyLoggedOut = false;
    _isSessionReady = true;

    await requestNotificationPermissionOnce();

    final apnsReady = await _ensureApnsTokenReady(startEpoch);
    if (apnsReady && !_isLoggingOut && startEpoch == _sessionEpoch) {
      try {
        final fcmToken = await _tokenProvider();
        if (fcmToken != null &&
            fcmToken.trim().isNotEmpty &&
            !_isLoggingOut &&
            startEpoch == _sessionEpoch) {
          await _registerTokenIfAuthenticated(
            fcmToken.trim(),
            verifiedAccessToken: accessToken,
            expectedEpoch: startEpoch,
          );
        } else {
          debugPrint(
            'FCM diagnostic: getToken() returned null or empty; '
            'awaiting onTokenRefresh.',
          );
        }
      } catch (e) {
        debugPrint('Failed to retrieve FCM token: ${e.runtimeType}');
      }
    }

    if (!_isLoggingOut && startEpoch == _sessionEpoch) {
      _consumePendingTapNavigation();
    }
  }

  Future<bool> _ensureApnsTokenReady(int expectedEpoch) async {
    if (!_requiresApnsCheck) {
      _lastApnsTokenAvailable = true;
      return true;
    }

    for (var attempt = 0; attempt <= maxApnsRetries; attempt++) {
      if (_isLoggingOut || expectedEpoch != _sessionEpoch) {
        return false;
      }

      try {
        final apnsToken = await _apnsTokenProvider();
        if (apnsToken != null && apnsToken.trim().isNotEmpty) {
          _lastApnsTokenAvailable = true;
          return true;
        }
      } catch (e) {
        debugPrint('APNs token check warning: ${e.runtimeType}');
      }

      if (attempt < maxApnsRetries && apnsRetryDelay > Duration.zero) {
        await Future<void>.delayed(apnsRetryDelay);
      }
    }

    _lastApnsTokenAvailable = false;
    debugPrint(
      'FCM iOS diagnostic: APNs token unavailable after '
      '${maxApnsRetries + 1} attempts. Verify Push Notifications capability '
      '(aps-environment entitlement) and Apple Developer / Firebase APNs '
      '(.p8) configuration.',
    );
    return false;
  }

  Future<void> _registerTokenIfAuthenticated(
    String fcmToken, {
    String? verifiedAccessToken,
    required int expectedEpoch,
  }) async {
    if (_isLoggingOut || expectedEpoch != _sessionEpoch) return;

    final trimmedFcmToken = fcmToken.trim();
    if (trimmedFcmToken.isEmpty) return;

    final accessToken =
        verifiedAccessToken ?? (await secureStorage.getAccessToken())?.trim();
    if (accessToken == null ||
        accessToken.isEmpty ||
        _isLoggingOut ||
        expectedEpoch != _sessionEpoch) {
      return;
    }

    if (_lastSyncedFcmToken == trimmedFcmToken &&
        _lastSyncedAccessToken == accessToken) {
      return;
    }

    final result = await updateFcmToken(trimmedFcmToken);
    if (_isLoggingOut || expectedEpoch != _sessionEpoch) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint('FCM token registration failed: ${failure.message}');
      },
      (_) {
        _lastSyncedFcmToken = trimmedFcmToken;
        _lastSyncedAccessToken = accessToken;
      },
    );
  }

  Future<void> _handleNotificationTap(
    RemoteMessage message, {
    required bool isInitialLaunch,
  }) async {
    final parsed = parseRemoteMessage(
      message,
      platform: _currentPlatform,
      isForeground: false,
    );

    await _processTapNavigation(
      deduplicationKey: parsed.deduplicationKey,
      targetRoute: parsed.targetRoute,
      isInitialLaunch: isInitialLaunch,
    );
  }

  Future<void> _handleLocalNotificationPayloadTap(
    Map<String, dynamic> data, {
    required bool isInitialLaunch,
  }) async {
    final nestedData = _extractNestedMap(data['data']);
    final mergedData = <String, dynamic>{...nestedData, ...data};
    final dedupKey =
        _nonEmptyString(mergedData['_deduplication_key']) ??
        _nonEmptyString(mergedData['notification_id']) ??
        _nonEmptyString(mergedData['id']);
    final targetRoute = resolveTargetRoute(mergedData);

    await _processTapNavigation(
      deduplicationKey: dedupKey,
      targetRoute: targetRoute,
      isInitialLaunch: isInitialLaunch,
    );
  }

  Future<void> _processTapNavigation({
    required String? deduplicationKey,
    required String targetRoute,
    required bool isInitialLaunch,
  }) async {
    if (deduplicationKey != null) {
      if (_processedTapKeys.contains(deduplicationKey)) {
        return;
      }
      _rememberBoundedKey(_processedTapKeys, deduplicationKey);
    }

    if (isInitialLaunch || !_isSessionReady || _isLoggingOut) {
      _pendingTapRoute = targetRoute;
      return;
    }

    final accessToken = (await secureStorage.getAccessToken())?.trim();
    if (accessToken != null && accessToken.isNotEmpty && !_isLoggingOut) {
      _onNavigate(targetRoute);
    } else {
      _pendingTapRoute = targetRoute;
    }
  }

  void _consumePendingTapNavigation() {
    final route = _pendingTapRoute;
    if (route == null) return;
    _pendingTapRoute = null;
    _onNavigate(route);
  }

  void _rememberBoundedKey(Set<String> set, String key) {
    if (set.length >= 100) {
      set.remove(set.first);
    }
    set.add(key);
  }

  /// Safely handles user logout and account switching:
  /// 1. Increments [_sessionEpoch] so in-flight callbacks cannot register tokens.
  /// 2. Calls `POST /api/auth/logout` best-effort while Bearer token is still present.
  /// 3. Deletes the device FCM token best-effort so pushes for the previous user stop.
  /// 4. Always clears local and secure session storage even if network or token deletion fails.
  Future<void> handleLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    _hasExplicitlyLoggedOut = true;
    _sessionEpoch++;
    _isSessionReady = false;
    _lastSyncedFcmToken = null;
    _lastSyncedAccessToken = null;
    _pendingTapRoute = null;

    try {
      final accessToken = (await secureStorage.getAccessToken())?.trim();
      if (accessToken != null &&
          accessToken.isNotEmpty &&
          apiConsumer != null) {
        try {
          await apiConsumer!.post(ApiEndpoints.logout);
        } catch (e) {
          debugPrint('Backend logout request failed: ${e.runtimeType}');
        }
      }

      try {
        await _tokenDeleter();
      } catch (e) {
        debugPrint('FCM deleteToken warning: ${e.runtimeType}');
      }
    } finally {
      try {
        await secureStorage.clearSession();
      } catch (e) {
        debugPrint('SecureStorage clearSession warning: ${e.runtimeType}');
      }
      try {
        await localStorage.clearSession();
        await localStorage.removeKeepMeSignedIn();
      } catch (e) {
        debugPrint('LocalStorage clearSession warning: ${e.runtimeType}');
      }
      _isLoggingOut = false;
    }
  }

  Future<void> dispose() async {
    _sessionEpoch++;
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
    await _messageOpenedAppSubscription?.cancel();
    await _foregroundNotificationController.close();
    await _foregroundParsedController.close();
  }
}
