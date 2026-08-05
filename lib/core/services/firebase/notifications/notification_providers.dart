import 'package:aetherdesk/core/services/firebase/notifications/not_configured_notification_service.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_repository.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_repository_impl.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return const NotConfiguredNotificationService();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationServiceProvider));
});
