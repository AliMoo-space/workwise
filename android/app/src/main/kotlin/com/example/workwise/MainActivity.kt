package com.example.workwise

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterFragmentActivity() {
    private var notificationChannel: MethodChannel? = null
    private var pendingInitialPayload: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WorkWiseNotificationHelper.ensureNotificationChannel(applicationContext)
        captureIntentPayload(intent, deliverImmediately = false)
    }

    override fun onStart() {
        super.onStart()
        WorkWiseNotificationHelper.isAppInForeground = true
    }

    override fun onResume() {
        super.onResume()
        WorkWiseNotificationHelper.isAppInForeground = true
    }

    override fun onPause() {
        WorkWiseNotificationHelper.isAppInForeground = false
        super.onPause()
    }

    override fun onStop() {
        WorkWiseNotificationHelper.isAppInForeground = false
        super.onStop()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureIntentPayload(intent, deliverImmediately = true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WorkWiseNotificationHelper.METHOD_CHANNEL_NAME
        )
        notificationChannel = channel
        channel.setMethodCallHandler { call, result ->
            handleMethodCall(call, result)
        }
    }

    override fun onDestroy() {
        notificationChannel?.setMethodCallHandler(null)
        notificationChannel = null
        super.onDestroy()
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                val channelId = call.argument<String>("channelId")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_ID
                val channelName = call.argument<String>("channelName")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_NAME
                val channelDescription = call.argument<String>("channelDescription")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_DESCRIPTION

                WorkWiseNotificationHelper.ensureNotificationChannel(
                    context = applicationContext,
                    channelId = channelId,
                    channelName = channelName,
                    channelDescription = channelDescription
                )
                val initialPayload = pendingInitialPayload
                pendingInitialPayload = null
                result.success(initialPayload)
            }

            "showNotification" -> {
                val id = call.argument<Int>("id") ?: WorkWiseNotificationHelper.nextNotificationId()
                val title = call.argument<String>("title")
                val body = call.argument<String>("body")
                val channelId = call.argument<String>("channelId")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_ID
                val channelName = call.argument<String>("channelName")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_NAME
                val channelDescription = call.argument<String>("channelDescription")
                    ?: WorkWiseNotificationHelper.DEFAULT_CHANNEL_DESCRIPTION
                val deduplicationKey = call.argument<String>("deduplicationKey")
                val payload = call.argument<String>("payload")

                WorkWiseNotificationHelper.showNotification(
                    context = applicationContext,
                    notificationId = id,
                    title = title,
                    body = body,
                    channelId = channelId,
                    channelName = channelName,
                    channelDescription = channelDescription,
                    deduplicationKey = deduplicationKey,
                    payloadJson = payload
                )
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun captureIntentPayload(intent: Intent?, deliverImmediately: Boolean) {
        if (intent == null) return
        val payload = intent.getStringExtra(WorkWiseNotificationHelper.EXTRA_NOTIFICATION_PAYLOAD)
            ?.takeIf { it.isNotBlank() }
            ?: return
        intent.removeExtra(WorkWiseNotificationHelper.EXTRA_NOTIFICATION_PAYLOAD)

        val channel = notificationChannel
        if (deliverImmediately && channel != null) {
            channel.invokeMethod("onNotificationTapped", payload)
        } else {
            pendingInitialPayload = payload
        }
    }
}

/**
 * Handles background/terminated data-only FCM broadcasts on Android so data-only
 * messages with visible content are displayed even when the app is not in the
 * foreground, while never duplicating messages that already contain a system
 * `notification` block.
 */
class WorkWiseFcmDataReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val appContext = context.applicationContext
        WorkWiseNotificationHelper.ensureNotificationChannel(appContext)

        if (WorkWiseNotificationHelper.isAppInForeground) {
            // Foreground messages are handled via FirebaseMessaging.onMessage in Dart.
            return
        }

        val extras = intent?.extras ?: return
        if (WorkWiseNotificationHelper.hasSystemNotificationPayload(extras)) {
            // Android OS / FCM SDK automatically displays `notification` payloads in background.
            return
        }

        val parsed = WorkWiseNotificationHelper.extractDataOnlyNotification(extras) ?: return
        WorkWiseNotificationHelper.showNotification(
            context = appContext,
            notificationId = parsed.notificationId,
            title = parsed.title,
            body = parsed.body,
            deduplicationKey = parsed.deduplicationKey,
            payloadJson = parsed.payloadJson
        )
    }
}

internal object WorkWiseNotificationHelper {
    const val METHOD_CHANNEL_NAME = "com.example.workwise/local_notifications"
    const val DEFAULT_CHANNEL_ID = "workwise_high_importance_channel"
    const val DEFAULT_CHANNEL_NAME = "WorkWise Notifications"
    const val DEFAULT_CHANNEL_DESCRIPTION = "High importance notifications for WorkWise"
    const val EXTRA_NOTIFICATION_PAYLOAD = "workwise_notification_payload"

    @Volatile
    var isAppInForeground: Boolean = false

    private val recentDeduplicationKeys = LinkedHashSet<String>()

    fun ensureNotificationChannel(
        context: Context,
        channelId: String = DEFAULT_CHANNEL_ID,
        channelName: String = DEFAULT_CHANNEL_NAME,
        channelDescription: String = DEFAULT_CHANNEL_DESCRIPTION
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
            ?: return
        val channel = NotificationChannel(
            channelId,
            channelName,
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = channelDescription
            enableLights(true)
            enableVibration(true)
        }
        manager.createNotificationChannel(channel)
    }

    fun showNotification(
        context: Context,
        notificationId: Int,
        title: String?,
        body: String?,
        channelId: String = DEFAULT_CHANNEL_ID,
        channelName: String = DEFAULT_CHANNEL_NAME,
        channelDescription: String = DEFAULT_CHANNEL_DESCRIPTION,
        deduplicationKey: String? = null,
        payloadJson: String? = null
    ) {
        val cleanTitle = title?.trim()?.takeIf { it.isNotEmpty() }
        val cleanBody = body?.trim()?.takeIf { it.isNotEmpty() }
        if (cleanTitle == null && cleanBody == null) return

        val cleanDedupKey = deduplicationKey?.trim()?.takeIf { it.isNotEmpty() }
        if (cleanDedupKey != null && !rememberDeduplicationKey(cleanDedupKey)) {
            return
        }

        ensureNotificationChannel(
            context = context,
            channelId = channelId,
            channelName = channelName,
            channelDescription = channelDescription
        )

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
            ?: return

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            if (!payloadJson.isNullOrBlank()) {
                putExtra(EXTRA_NOTIFICATION_PAYLOAD, payloadJson)
            }
        }

        val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            notificationId,
            launchIntent,
            pendingIntentFlags
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
                .setPriority(Notification.PRIORITY_HIGH)
                .setDefaults(Notification.DEFAULT_ALL)
        }

        val smallIcon = context.applicationInfo.icon.takeIf { it != 0 }
            ?: android.R.drawable.ic_dialog_info

        builder
            .setSmallIcon(smallIcon)
            .setContentTitle(cleanTitle ?: "WorkWise")
            .setContentText(cleanBody ?: "")
            .setStyle(Notification.BigTextStyle().bigText(cleanBody ?: ""))
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)

        manager.notify(notificationId, builder.build())
    }

    fun hasSystemNotificationPayload(extras: Bundle): Boolean {
        val enableFlag = extras.getString("gcm.n.e") ?: extras.getString("gcm.notification.e")
        if (enableFlag == "1" || enableFlag.equals("true", ignoreCase = true)) {
            return true
        }
        val title = extras.getString("gcm.notification.title") ?: extras.getString("gcm.n.title")
        val body = extras.getString("gcm.notification.body") ?: extras.getString("gcm.n.body")
        return !title.isNullOrBlank() || !body.isNullOrBlank()
    }

    data class ParsedDataOnlyNotification(
        val notificationId: Int,
        val title: String?,
        val body: String?,
        val deduplicationKey: String?,
        val payloadJson: String
    )

    fun extractDataOnlyNotification(extras: Bundle): ParsedDataOnlyNotification? {
        val rawMap = mutableMapOf<String, Any?>()
        for (key in extras.keySet()) {
            val value = extras.get(key)
            if (value is String) {
                rawMap[key] = value
            }
        }

        val nestedData = parseJsonMap(rawMap["data"] as? String)
        val nestedNotification = parseJsonMap(rawMap["notification"] as? String)

        val title = nonEmpty(rawMap["title"])
            ?: nonEmpty(nestedData["title"])
            ?: nonEmpty(nestedNotification["title"])
        val body = nonEmpty(rawMap["body"])
            ?: nonEmpty(nestedData["body"])
            ?: nonEmpty(nestedNotification["body"])
            ?: nonEmpty(rawMap["message"])
            ?: nonEmpty(nestedData["message"])

        if (title == null && body == null) return null

        val messageId = nonEmpty(rawMap["google.message_id"])
            ?: nonEmpty(rawMap["message_id"])
        val notifId = nonEmpty(rawMap["notification_id"])
            ?: nonEmpty(rawMap["id"])
            ?: nonEmpty(nestedData["notification_id"])
            ?: nonEmpty(nestedData["id"])
        val type = nonEmpty(rawMap["type"]) ?: nonEmpty(nestedData["type"])

        val deduplicationKey = messageId
            ?: notifId
            ?: "${type ?: ""}|${title ?: ""}|${body ?: ""}"

        val mergedPayload = JSONObject()
        for ((k, v) in nestedData) {
            mergedPayload.put(k, v)
        }
        for ((k, v) in rawMap) {
            if (!k.startsWith("google.") && !k.startsWith("gcm.") && k != "from" && k != "collapse_key") {
                mergedPayload.put(k, v)
            }
        }
        mergedPayload.put("_deduplication_key", deduplicationKey)

        val stableId = (deduplicationKey.hashCode() and 0x7fffffff)
        return ParsedDataOnlyNotification(
            notificationId = stableId,
            title = title,
            body = body,
            deduplicationKey = deduplicationKey,
            payloadJson = mergedPayload.toString()
        )
    }

    fun nextNotificationId(): Int =
        ((System.currentTimeMillis() and 0x7fffffff).toInt())

    @Synchronized
    private fun rememberDeduplicationKey(key: String): Boolean {
        if (recentDeduplicationKeys.contains(key)) {
            return false
        }
        if (recentDeduplicationKeys.size >= 100) {
            val first = recentDeduplicationKeys.iterator().next()
            recentDeduplicationKeys.remove(first)
        }
        recentDeduplicationKeys.add(key)
        return true
    }

    private fun parseJsonMap(raw: String?): Map<String, String> {
        val trimmed = raw?.trim() ?: return emptyMap()
        if (!trimmed.startsWith("{")) return emptyMap()
        return try {
            val json = JSONObject(trimmed)
            val result = mutableMapOf<String, String>()
            val keys = json.keys()
            while (keys.hasNext()) {
                val key = keys.next()
                val value = json.opt(key)
                if (value != null && value != JSONObject.NULL) {
                    result[key] = value.toString()
                }
            }
            result
        } catch (_: Exception) {
            emptyMap()
        }
    }

    private fun nonEmpty(value: Any?): String? {
        val str = value as? String ?: return null
        val trimmed = str.trim()
        return if (trimmed.isEmpty()) null else trimmed
    }
}