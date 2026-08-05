import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_repository.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._service);
  final NotificationService _service;

  @override
  Future<bool> requestPermission() => _service.requestPermission();

  @override
  Stream<PushNotification> messages() => _service.onMessageReceived();

  @override
  Future<void> subscribeToTopic(String topic) =>
      _service.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) =>
      _service.unsubscribeFromTopic(topic);
}
