import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;

/// Real [NotificationService] backed by `firebase_messaging` (Firebase
/// Cloud Messaging).
class RealNotificationService implements NotificationService {
  RealNotificationService({fcm.FirebaseMessaging? messaging})
    : _messaging = messaging ?? fcm.FirebaseMessaging.instance;

  final fcm.FirebaseMessaging _messaging;

  @override
  Future<String?> getDeviceToken() => _messaging.getToken();

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == fcm.AuthorizationStatus.authorized ||
        settings.authorizationStatus == fcm.AuthorizationStatus.provisional;
  }

  @override
  Stream<PushNotification> onMessageReceived() {
    return fcm.FirebaseMessaging.onMessage.map((message) {
      final notification = message.notification;
      return PushNotification(
        id:
            message.messageId ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        title: notification?.title ?? '',
        body: notification?.body ?? '',
        data: message.data.map((key, value) => MapEntry(key, value.toString())),
        receivedAt: DateTime.now(),
      );
    });
  }

  @override
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}
