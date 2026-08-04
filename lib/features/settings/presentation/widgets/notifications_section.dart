import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local preference toggles only — there is no `NotificationService`
/// wired in yet (see `core/services/firebase/` architecture), so nothing
/// is actually scheduled or sent.
class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

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
            onChanged: controller.setNotificationsEnabled,
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
