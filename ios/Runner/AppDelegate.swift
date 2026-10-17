import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let localNotificationChannelName = "com.alimohamed.workwise/local_notifications"
  private static let localPayloadKey = "workwise_local_payload"

  private var localNotificationChannel: FlutterMethodChannel?
  private var pendingInitialPayload: String?
  private var recentDeduplicationKeys = Set<String>()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "WorkWiseLocalNotifications"
    ) {
      let channel = FlutterMethodChannel(
        name: Self.localNotificationChannelName,
        binaryMessenger: registrar.messenger()
      )
      localNotificationChannel = channel
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleLocalNotificationCall(call, result: result)
      }
    }
  }

  private func handleLocalNotificationCall(
    _ call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "initialize":
      let initialPayload = pendingInitialPayload
      pendingInitialPayload = nil
      result(initialPayload)

    case "showNotification":
      guard let args = call.arguments as? [String: Any] else {
        result(nil)
        return
      }
      let title = (args["title"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
      let body = (args["body"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
      if (title == nil || title!.isEmpty) && (body == nil || body!.isEmpty) {
        result(nil)
        return
      }

      if let dedupKey = (args["deduplicationKey"] as? String)?
        .trimmingCharacters(in: .whitespacesAndNewlines),
        !dedupKey.isEmpty
      {
        if recentDeduplicationKeys.contains(dedupKey) {
          result(nil)
          return
        }
        if recentDeduplicationKeys.count >= 100, let first = recentDeduplicationKeys.first {
          recentDeduplicationKeys.remove(first)
        }
        recentDeduplicationKeys.insert(dedupKey)
      }

      let content = UNMutableNotificationContent()
      content.title = (title?.isEmpty == false) ? title! : "WorkWise"
      content.body = body ?? ""
      content.sound = .default
      if let payload = args["payload"] as? String, !payload.isEmpty {
        content.userInfo = [Self.localPayloadKey: payload]
      }

      let identifier = (args["deduplicationKey"] as? String)
        ?? String(args["id"] as? Int ?? Int(Date().timeIntervalSince1970))
      let request = UNNotificationRequest(
        identifier: identifier,
        content: content,
        trigger: nil
      )
      UNUserNotificationCenter.current().add(request) { _ in
        result(nil)
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if notification.request.content.userInfo[Self.localPayloadKey] != nil {
      if #available(iOS 14.0, *) {
        completionHandler([.banner, .list, .sound, .badge])
      } else {
        completionHandler([.alert, .sound, .badge])
      }
      return
    }
    super.userNotificationCenter(
      center,
      willPresent: notification,
      withCompletionHandler: completionHandler
    )
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if let payload = response.notification.request.content.userInfo[Self.localPayloadKey] as? String,
      !payload.isEmpty
    {
      if let channel = localNotificationChannel {
        channel.invokeMethod("onNotificationTapped", arguments: payload)
      } else {
        pendingInitialPayload = payload
      }
      completionHandler()
      return
    }
    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
    )
  }
}

