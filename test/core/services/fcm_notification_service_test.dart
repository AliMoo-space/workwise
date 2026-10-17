import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workwise/core/errors/failure.dart';
import 'package:workwise/core/network/api_consumer.dart';
import 'package:workwise/core/network/endpoints/api_endpoints.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/core/services/fcm_notification_service.dart';
import 'package:workwise/core/storage/local_storage.dart';
import 'package:workwise/core/storage/secure_storage.dart';
import 'package:workwise/features/notification/domain/entities/notification_entity.dart';
import 'package:workwise/features/notification/domain/repo/notification_repository.dart';
import 'package:workwise/features/notification/domain/usecases/notification_actions.dart';

class InMemorySecureStorage extends SecureStorage {
  InMemorySecureStorage() : super(const FlutterSecureStorage());

  String? token;

  @override
  Future<void> saveAccessToken(String token) async {
    this.token = token;
  }

  @override
  Future<String?> getAccessToken() async => token;

  @override
  Future<void> removeAccessToken() async {
    token = null;
  }

  @override
  Future<void> clearSession() async {
    token = null;
  }
}

class FakeLocalNotificationPresenter implements FcmLocalNotificationPresenter {
  int initializeCalls = 0;
  final List<FcmParsedNotification> shownNotifications = [];
  LocalNotificationTapCallback? tapCallback;
  Map<String, dynamic>? initialTapPayload;

  @override
  Future<void> initialize({
    LocalNotificationTapCallback? onNotificationTapped,
  }) async {
    initializeCalls++;
    tapCallback = onNotificationTapped;
    if (initialTapPayload != null && onNotificationTapped != null) {
      await onNotificationTapped(initialTapPayload!, isInitialLaunch: true);
    }
  }

  @override
  Future<void> showNotification(FcmParsedNotification notification) async {
    shownNotifications.add(notification);
  }

  Future<void> simulateTap(
    Map<String, dynamic> data, {
    bool isInitialLaunch = false,
  }) async {
    if (tapCallback != null) {
      await tapCallback!(data, isInitialLaunch: isInitialLaunch);
    }
  }
}

class FakeFcmNotificationRepo implements NotificationRepository {
  final List<String> registeredTokens = [];
  Either<Failure, void> nextResult = const Right(null);
  Completer<Either<Failure, void>>? pendingResultCompleter;

  @override
  Future<Either<Failure, void>> updateFcmToken(String fcmToken) async {
    if (pendingResultCompleter != null) {
      final res = await pendingResultCompleter!.future;
      if (res.isRight()) {
        registeredTokens.add(fcmToken);
      }
      return res;
    }
    if (nextResult.isRight()) {
      registeredTokens.add(fcmToken);
    }
    return nextResult;
  }

  @override
  Future<Either<Failure, NotificationPageEntity>> getNotifications({
    int? perPage,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> clearAllNotifications() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteNotification(String id) =>
      throw UnimplementedError();
}

class FakeLogoutApiConsumer implements ApiConsumer {
  int logoutPostCalls = 0;
  String? lastPostPath;
  bool shouldThrowOnLogout = false;

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPostPath = path;
    if (path == ApiEndpoints.logout) {
      logoutPostCalls++;
      if (shouldThrowOnLogout) {
        throw Exception('Network error during logout');
      }
    }
    return Response(
      data: {'success': true},
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError();

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError();

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError();

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemorySecureStorage secureStorage;
  late LocalStorage localStorage;
  late FakeFcmNotificationRepo fakeRepo;
  late FakeLogoutApiConsumer fakeApiConsumer;
  late FakeLocalNotificationPresenter fakeLocalPresenter;
  late StreamController<String> tokenRefreshController;
  late StreamController<RemoteMessage> foregroundMessageController;
  late StreamController<RemoteMessage> messageOpenedAppController;
  late RemoteMessage? initialMessage;
  late String? currentDeviceFcmToken;
  late List<String?> apnsTokenSequence;
  late int apnsCheckCalls;
  late int deleteTokenCalls;
  late bool shouldThrowOnDeleteToken;
  late int permissionRequestCalls;
  late List<String> navigatedRoutes;
  late TargetPlatform testPlatform;
  late bool requiresApnsCheck;
  late FcmNotificationService service;

  FcmNotificationService createService() {
    return FcmNotificationService(
      updateFcmToken: UpdateFcmToken(fakeRepo),
      secureStorage: secureStorage,
      localStorage: localStorage,
      apiConsumer: fakeApiConsumer,
      localNotificationPresenter: fakeLocalPresenter,
      tokenProvider: () async => currentDeviceFcmToken,
      apnsTokenProvider: () async {
        apnsCheckCalls++;
        if (apnsTokenSequence.isEmpty) return 'apns-ready';
        if (apnsCheckCalls <= apnsTokenSequence.length) {
          return apnsTokenSequence[apnsCheckCalls - 1];
        }
        return apnsTokenSequence.last;
      },
      tokenDeleter: () async {
        deleteTokenCalls++;
        if (shouldThrowOnDeleteToken) {
          throw Exception('APNs token not set during deleteToken');
        }
      },
      tokenRefreshStreamProvider: () => tokenRefreshController.stream,
      foregroundMessageStreamProvider: () => foregroundMessageController.stream,
      messageOpenedAppStreamProvider: () => messageOpenedAppController.stream,
      initialMessageProvider: () async => initialMessage,
      permissionRequester: () async {
        permissionRequestCalls++;
        return AuthorizationStatus.authorized;
      },
      foregroundOptionsSetter: () async {},
      onNavigate: navigatedRoutes.add,
      platformOverride: testPlatform,
      requiresApnsCheckOverride: requiresApnsCheck,
      maxApnsRetries: 2,
      apnsRetryDelay: const Duration(milliseconds: 5),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorage(prefs);
    secureStorage = InMemorySecureStorage();
    fakeRepo = FakeFcmNotificationRepo();
    fakeApiConsumer = FakeLogoutApiConsumer();
    fakeLocalPresenter = FakeLocalNotificationPresenter();
    tokenRefreshController = StreamController<String>.broadcast();
    foregroundMessageController = StreamController<RemoteMessage>.broadcast();
    messageOpenedAppController = StreamController<RemoteMessage>.broadcast();
    initialMessage = null;
    currentDeviceFcmToken = 'fcm-device-token-1';
    apnsTokenSequence = ['apns-token-ok'];
    apnsCheckCalls = 0;
    deleteTokenCalls = 0;
    shouldThrowOnDeleteToken = false;
    permissionRequestCalls = 0;
    navigatedRoutes = [];
    testPlatform = TargetPlatform.android;
    requiresApnsCheck = false;

    service = createService();
  });

  tearDown(() async {
    await service.dispose();
    await tokenRefreshController.close();
    await foregroundMessageController.close();
    await messageOpenedAppController.close();
  });

  group('Foreground notification parsing and display decisions', () {
    test(
      'Android foreground notification with notification block sets shouldDisplayInAppBanner and shouldDisplayLocalNotification true',
      () {
        const message = RemoteMessage(
          messageId: 'msg-1',
          notification: RemoteNotification(
            title: 'Task Assigned',
            body: 'Review Q4 report',
          ),
          data: {'id': 'notif-10', 'type': 'task'},
        );

        final parsed = FcmNotificationService.parseRemoteMessage(
          message,
          platform: TargetPlatform.android,
          isForeground: true,
        );

        expect(parsed.title, 'Task Assigned');
        expect(parsed.body, 'Review Q4 report');
        expect(parsed.notificationId, 'notif-10');
        expect(parsed.hasSystemNotificationBlock, isTrue);
        expect(parsed.shouldDisplayInAppBanner, isTrue);
        expect(parsed.shouldDisplayLocalNotification, isTrue);
        expect(parsed.targetRoute, AppRoutes.notificationScreen);
      },
    );

    test(
      'iOS foreground notification with system notification block sets shouldDisplayInAppBanner and shouldDisplayLocalNotification false to avoid duplicate display',
      () {
        const message = RemoteMessage(
          messageId: 'msg-ios-1',
          notification: RemoteNotification(
            title: 'Leave Approved',
            body: 'Your leave request was approved',
          ),
        );

        final parsed = FcmNotificationService.parseRemoteMessage(
          message,
          platform: TargetPlatform.iOS,
          isForeground: true,
        );

        expect(parsed.hasSystemNotificationBlock, isTrue);
        expect(parsed.shouldDisplayInAppBanner, isFalse);
        expect(parsed.shouldDisplayLocalNotification, isFalse);
      },
    );

    test(
      'iOS foreground data-only message with title/body sets shouldDisplayInAppBanner and shouldDisplayLocalNotification true',
      () {
        const message = RemoteMessage(
          messageId: 'msg-ios-data',
          data: {'data': '{"title":"Data Alert","body":"Check your schedule"}'},
        );

        final parsed = FcmNotificationService.parseRemoteMessage(
          message,
          platform: TargetPlatform.iOS,
          isForeground: true,
        );

        expect(parsed.title, 'Data Alert');
        expect(parsed.body, 'Check your schedule');
        expect(parsed.hasSystemNotificationBlock, isFalse);
        expect(parsed.shouldDisplayInAppBanner, isTrue);
        expect(parsed.shouldDisplayLocalNotification, isTrue);
      },
    );

    test('handles missing title, body, and data fields safely', () {
      const message = RemoteMessage();

      final parsed = FcmNotificationService.parseRemoteMessage(
        message,
        platform: TargetPlatform.android,
        isForeground: true,
      );

      expect(parsed.title, isNull);
      expect(parsed.body, isNull);
      expect(parsed.notificationId, isNull);
      expect(parsed.hasVisibleContent, isFalse);
      expect(parsed.shouldDisplayInAppBanner, isFalse);
      expect(parsed.shouldDisplayLocalNotification, isFalse);
      expect(parsed.targetRoute, AppRoutes.notificationScreen);
    });

    test(
      'displays foreground local notification on Android for notification, data-only, and combined payloads without duplicates',
      () async {
        secureStorage.token = 'bearer-token';
        await service.initialize();
        expect(fakeLocalPresenter.initializeCalls, 1);

        // 1. Notification-only payload
        foregroundMessageController.add(
          const RemoteMessage(
            messageId: 'fg-notif-1',
            notification: RemoteNotification(
              title: 'New Task',
              body: 'You have been assigned a new task.',
            ),
          ),
        );

        // 2. Data-only payload (nested data JSON matching Laravel schema)
        foregroundMessageController.add(
          const RemoteMessage(
            messageId: 'fg-data-2',
            data: {
              'id': '9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d',
              'type': r'App\Notifications\NewTaskNotification',
              'data':
                  '{"title":"Data Task","body":"Assigned via data payload"}',
            },
          ),
        );

        // 3. Combined notification + data payload (plus duplicate delivery)
        const combinedMsg = RemoteMessage(
          messageId: 'fg-combined-3',
          notification: RemoteNotification(
            title: 'Goal Updated',
            body: 'Your goal progress changed.',
          ),
          data: {'type': 'goal', 'goal_id': '12'},
        );
        foregroundMessageController.add(combinedMsg);
        foregroundMessageController.add(combinedMsg);

        await Future<void>.delayed(const Duration(milliseconds: 30));

        expect(fakeLocalPresenter.shownNotifications.length, 3);
        expect(fakeLocalPresenter.shownNotifications[0].title, 'New Task');
        expect(fakeLocalPresenter.shownNotifications[1].title, 'Data Task');
        expect(fakeLocalPresenter.shownNotifications[2].title, 'Goal Updated');
        expect(
          fakeLocalPresenter.shownNotifications[2].targetRoute,
          '${AppRoutes.goalDetailsScreen}/12',
        );
      },
    );

    test(
      'does not display duplicate local notification on iOS foreground when system notification block is present',
      () async {
        testPlatform = TargetPlatform.iOS;
        service = createService();
        secureStorage.token = 'bearer-token';
        await service.initialize();

        foregroundMessageController.add(
          const RemoteMessage(
            messageId: 'ios-fg-system',
            notification: RemoteNotification(
              title: 'System Alert',
              body: 'Presented by iOS UNUserNotificationCenter',
            ),
          ),
        );
        foregroundMessageController.add(
          const RemoteMessage(
            messageId: 'ios-fg-data-only',
            data: {'title': 'Data Only on iOS', 'body': 'Shown locally'},
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 30));

        expect(fakeLocalPresenter.shownNotifications.length, 1);
        expect(
          fakeLocalPresenter.shownNotifications.single.title,
          'Data Only on iOS',
        );
      },
    );

    test(
      'deduplicates identical foreground messages and emits refresh signal once',
      () async {
        secureStorage.token = 'bearer-token';
        await service.initialize();

        var refreshCount = 0;
        final sub = service.onForegroundNotification.listen((_) {
          refreshCount++;
        });

        const msg = RemoteMessage(
          messageId: 'dup-msg-1',
          notification: RemoteNotification(title: 'Ping', body: 'Hello'),
        );

        foregroundMessageController.add(msg);
        foregroundMessageController.add(msg);
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await sub.cancel();

        expect(refreshCount, 1);
        expect(fakeLocalPresenter.shownNotifications.length, 1);
      },
    );
  });

  group('Background handler & duplicate prevention', () {
    test(
      'firebaseMessagingBackgroundHandler runs custom initializer safely without throwing on error',
      () async {
        var initialized = false;
        await firebaseMessagingBackgroundHandler(
          const RemoteMessage(messageId: 'bg-1'),
          firebaseInitializer: () async {
            initialized = true;
          },
          localNotificationPresenter: fakeLocalPresenter,
        );
        expect(initialized, isTrue);

        // Also verify exceptions inside background initializer are caught safely
        await firebaseMessagingBackgroundHandler(
          const RemoteMessage(messageId: 'bg-2'),
          firebaseInitializer: () async {
            throw Exception('Simulated background init error');
          },
          localNotificationPresenter: fakeLocalPresenter,
        );
      },
    );

    test(
      'background handler does NOT display local notification when message has system notification block (preventing duplicates)',
      () async {
        await firebaseMessagingBackgroundHandler(
          const RemoteMessage(
            messageId: 'bg-system-notif',
            notification: RemoteNotification(
              title: 'Background Alert',
              body: 'Displayed by Android/iOS OS system tray',
            ),
            data: {'id': '100', 'type': 'task'},
          ),
          firebaseInitializer: () async {},
          localNotificationPresenter: fakeLocalPresenter,
          platformOverride: TargetPlatform.android,
        );

        expect(fakeLocalPresenter.shownNotifications, isEmpty);
      },
    );

    test(
      'background handler displays local notification once for data-only message with visible content',
      () async {
        await firebaseMessagingBackgroundHandler(
          const RemoteMessage(
            messageId: 'bg-data-only-1',
            data: {
              'id': 'notif-200',
              'type': 'leave',
              'data':
                  '{"title":"Leave Update","body":"Your leave was reviewed"}',
            },
          ),
          firebaseInitializer: () async {},
          localNotificationPresenter: fakeLocalPresenter,
          platformOverride: TargetPlatform.android,
        );

        expect(fakeLocalPresenter.shownNotifications.length, 1);
        expect(
          fakeLocalPresenter.shownNotifications.single.title,
          'Leave Update',
        );
        expect(
          fakeLocalPresenter.shownNotifications.single.body,
          'Your leave was reviewed',
        );
      },
    );
  });

  group('MethodChannelFcmLocalNotificationPresenter & tap routing', () {
    test(
      'initializes Android channel and forwards showNotification & tap events over MethodChannel',
      () async {
        const testChannel = MethodChannel(
          'com.alimohamed.workwise/test_local_notifications',
        );
        final recordedCalls = <MethodCall>[];

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(testChannel, (call) async {
              recordedCalls.add(call);
              if (call.method == 'initialize') {
                return jsonEncode({
                  'route': AppRoutes.leaveScreen,
                  '_deduplication_key': 'init-local-tap-1',
                });
              }
              return null;
            });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(testChannel, null);
        });

        final presenter = MethodChannelFcmLocalNotificationPresenter(
          channel: testChannel,
        );

        final tappedPayloads = <Map<String, dynamic>>[];
        final initialFlags = <bool>[];
        await presenter.initialize(
          onNotificationTapped: (data, {required isInitialLaunch}) async {
            tappedPayloads.add(data);
            initialFlags.add(isInitialLaunch);
          },
        );

        expect(recordedCalls.length, 1);
        expect(recordedCalls.first.method, 'initialize');
        expect(
          (recordedCalls.first.arguments as Map)['channelId'],
          FcmNotificationService.androidNotificationChannelId,
        );
        expect(tappedPayloads.length, 1);
        expect(initialFlags, [true]);

        final parsed = FcmNotificationService.parseRemoteMessage(
          const RemoteMessage(
            messageId: 'mc-msg-1',
            notification: RemoteNotification(
              title: 'Check In Reminder',
              body: 'Do not forget to check in',
            ),
            data: {'route': AppRoutes.attendanceScreen},
          ),
          platform: TargetPlatform.android,
          isForeground: true,
        );

        await presenter.showNotification(parsed);
        expect(recordedCalls.length, 2);
        expect(recordedCalls[1].method, 'showNotification');
        final showArgs = Map<String, dynamic>.from(
          recordedCalls[1].arguments as Map,
        );
        expect(showArgs['title'], 'Check In Reminder');
        expect(showArgs['body'], 'Do not forget to check in');
        expect(
          showArgs['channelId'],
          FcmNotificationService.androidNotificationChannelId,
        );
        expect(showArgs['deduplicationKey'], 'mc-msg-1');
      },
    );

    test(
      'tapping a displayed local notification navigates to validated route and deduplicates',
      () async {
        secureStorage.token = 'bearer-valid';
        await service.initialize();
        await service.syncTokenIfAuthenticated();

        await fakeLocalPresenter.simulateTap({
          '_deduplication_key': 'local-tap-1',
          'type': 'goal',
          'goal_id': '77',
        });
        await fakeLocalPresenter.simulateTap({
          '_deduplication_key': 'local-tap-1',
          'type': 'goal',
          'goal_id': '77',
        });

        expect(navigatedRoutes, ['${AppRoutes.goalDetailsScreen}/77']);
      },
    );
  });

  group('Terminated launch, background tap routing & payload validation', () {
    test(
      'defers getInitialMessage navigation until authenticated session is ready and prevents duplicate navigation',
      () async {
        secureStorage.token = 'bearer-valid';
        initialMessage = const RemoteMessage(
          messageId: 'cold-start-1',
          data: {'type': 'goal_assigned', 'goal_id': '42'},
        );

        await service.initialize();

        // Should NOT navigate before SplashCubit / LoginCubit confirms session readiness
        expect(navigatedRoutes, isEmpty);

        // Once session is restored:
        await service.syncTokenIfAuthenticated();
        expect(navigatedRoutes, ['${AppRoutes.goalDetailsScreen}/42']);

        // Sending the same message again on onMessageOpenedApp is deduplicated:
        messageOpenedAppController.add(initialMessage!);
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(navigatedRoutes.length, 1);
      },
    );

    test(
      'handles background notification tap immediately when session is ready, or after login if logged out',
      () async {
        await service.initialize();

        // Tap while logged out:
        messageOpenedAppController.add(
          const RemoteMessage(
            messageId: 'tap-while-logged-out',
            data: {'route': AppRoutes.tasksScreen},
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(navigatedRoutes, isEmpty);

        // User logs in:
        secureStorage.token = 'bearer-after-login';
        await service.syncTokenIfAuthenticated();
        expect(navigatedRoutes, [AppRoutes.tasksScreen]);
      },
    );

    test(
      'rejects arbitrary untrusted routes and invalid goal IDs by falling back to notificationScreen',
      () {
        expect(
          FcmNotificationService.resolveTargetRoute({
            'route': 'https://evil.example.com',
          }),
          AppRoutes.notificationScreen,
        );
        expect(
          FcmNotificationService.resolveTargetRoute({
            'route': '/admin/delete-all',
          }),
          AppRoutes.notificationScreen,
        );
        expect(
          FcmNotificationService.resolveTargetRoute({
            'type': 'goal',
            'goal_id': '-5',
          }),
          AppRoutes.notificationScreen,
        );
        expect(
          FcmNotificationService.resolveTargetRoute({
            'type': 'goal',
            'goal_id': 'not-an-int',
          }),
          AppRoutes.notificationScreen,
        );
      },
    );
  });

  group('FCM token lifecycle, iOS APNs retry, network failure & logout', () {
    test('does not register FCM token when user is unauthenticated', () async {
      secureStorage.token = null;
      await service.initialize();

      await service.syncTokenIfAuthenticated();
      tokenRefreshController.add('refreshed-while-logged-out');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(fakeRepo.registeredTokens, isEmpty);
      expect(permissionRequestCalls, 1);
    });

    test(
      'registers FCM token when authenticated, deduplicates identical token, and registers refreshed token',
      () async {
        secureStorage.token = 'bearer-user-a';
        await service.initialize();

        await service.syncTokenIfAuthenticated();
        await service.syncTokenIfAuthenticated();
        expect(fakeRepo.registeredTokens, ['fcm-device-token-1']);

        tokenRefreshController.add('fcm-device-token-refreshed');
        await Future<void>.delayed(const Duration(milliseconds: 20));

        expect(fakeRepo.registeredTokens, [
          'fcm-device-token-1',
          'fcm-device-token-refreshed',
        ]);
      },
    );

    test(
      'iOS APNs unavailable initially then becoming available succeeds within bounded retries',
      () async {
        testPlatform = TargetPlatform.iOS;
        requiresApnsCheck = true;
        apnsTokenSequence = [null, '', 'apns-token-ready'];
        service = createService();

        secureStorage.token = 'bearer-ios-user';
        await service.syncTokenIfAuthenticated();

        expect(apnsCheckCalls, 3);
        expect(service.lastApnsTokenAvailable, isTrue);
        expect(fakeRepo.registeredTokens, ['fcm-device-token-1']);
      },
    );

    test(
      'iOS APNs remaining unavailable defers registration safely after bounded retries',
      () async {
        testPlatform = TargetPlatform.iOS;
        requiresApnsCheck = true;
        apnsTokenSequence = [null, null, null, null];
        service = createService();

        secureStorage.token = 'bearer-ios-user';
        await service.syncTokenIfAuthenticated();

        expect(apnsCheckCalls, 3); // 1 initial + 2 retries
        expect(service.lastApnsTokenAvailable, isFalse);
        expect(fakeRepo.registeredTokens, isEmpty);
      },
    );

    test(
      'retries token registration on subsequent call after transient network failure',
      () async {
        secureStorage.token = 'bearer-user-a';
        fakeRepo.nextResult = const Left(NetworkFailure('No internet'));

        await service.syncTokenIfAuthenticated();
        expect(fakeRepo.registeredTokens, isEmpty);

        // Network recovers:
        fakeRepo.nextResult = const Right(null);
        await service.syncTokenIfAuthenticated();
        expect(fakeRepo.registeredTokens, ['fcm-device-token-1']);
      },
    );

    test(
      'completes local session cleanup on logout even when backend logout and deleteToken fail, and suppresses post-logout foreground display',
      () async {
        secureStorage.token = 'bearer-user-a';
        await localStorage.saveUserId(10);
        await localStorage.saveKeepMeSignedIn(true);
        fakeApiConsumer.shouldThrowOnLogout = true;
        shouldThrowOnDeleteToken = true;

        await service.initialize();
        await service.handleLogout();

        expect(fakeApiConsumer.logoutPostCalls, 1);
        expect(deleteTokenCalls, 1);
        expect(await secureStorage.getAccessToken(), isNull);
        expect(localStorage.getUserId(), isNull);
        expect(localStorage.getKeepMeSignedIn(), isFalse);

        // Incoming message while explicitly logged out should not display
        foregroundMessageController.add(
          const RemoteMessage(
            messageId: 'post-logout-msg',
            notification: RemoteNotification(
              title: 'Old User Task',
              body: 'Should not appear after logout',
            ),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(fakeLocalPresenter.shownNotifications, isEmpty);
      },
    );

    test(
      'prevents in-flight token registration from completing or caching after logout and supports account switching',
      () async {
        secureStorage.token = 'bearer-user-a';
        fakeRepo.pendingResultCompleter = Completer<Either<Failure, void>>();

        final inFlightSync = service.syncTokenIfAuthenticated();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // User logs out while updateFcmToken request is still in flight
        await service.handleLogout();

        // Complete the old request after logout
        fakeRepo.pendingResultCompleter!.complete(const Right(null));
        await inFlightSync;
        fakeRepo.pendingResultCompleter = null;
        fakeRepo.registeredTokens.clear();

        // Late token refresh event while logged out must not register
        tokenRefreshController.add('fcm-device-token-1');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(fakeRepo.registeredTokens, isEmpty);

        // Account B logs in with the same device token — must register for Account B
        secureStorage.token = 'bearer-user-b';
        await service.syncTokenIfAuthenticated();
        expect(fakeRepo.registeredTokens, ['fcm-device-token-1']);
      },
    );
  });
}
