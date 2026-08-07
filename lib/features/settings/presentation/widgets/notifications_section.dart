import 'dart:async';

import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_providers.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real push notifications via Firebase Cloud Messaging: enabling the
/// toggle requests the OS notification permission and subscribes to the
/// `aetherdesk_updates` topic; disabling unsubscribes. No local server is
/// involved — messages would come from Firebase Console/Cloud Functions
/// publishing to that topic.
class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  static const _updatesTopic = 'aetherdesk_updates';

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.read(notificationRepositoryProvider);
    try {
      if (value) {
        final granted = await notifications.requestPermission();
        if (!granted) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.settingsNotificationsPermissionDeniedMessage),
            ),
          );
          return;
        }
        await notifications.subscribeToTopic(_updatesTopic);
      } else {
        await notifications.unsubscribeFromTopic(_updatesTopic);
      }
      ref
          .read(settingsControllerProvider.notifier)
          .setNotificationsEnabled(value);
    } on Exception {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsNotificationsErrorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return SettingsSectionCard(
      title: l10n.settingsNotificationsTitle,
      icon: Icons.notifications_outlined,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsNotificationsEnabledLabel),
            value: settings.notificationsEnabled,
            onChanged: (value) => unawaited(_setEnabled(context, ref, value)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsNotificationsSoundLabel),
            value: settings.notificationSoundEnabled,
            onChanged: settings.notificationsEnabled
                ? controller.setNotificationSoundEnabled
                : null,
          ),
        ],
      ),
    );
  }
}
