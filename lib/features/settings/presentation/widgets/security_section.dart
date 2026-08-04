import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/biometric/biometric_auth_service_provider.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The one screen that actually touches `core/services/biometric/` — but
/// only to check availability and inform the user, never to gate access to
/// the app or to `secure_vault` (see that service's doc comment on why).
class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);

    return SettingsSectionCard(
      title: l10n.settingsSecurityTitle,
      icon: Icons.security_outlined,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsBiometricLockLabel),
            subtitle: settings.biometricLockEnabled
                ? Text(l10n.settingsBiometricUnavailableMessage)
                : null,
            value: settings.biometricLockEnabled,
            onChanged: (value) => _setBiometricLock(context, ref, value),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.pin_outlined),
            title: Text(l10n.settingsPinCodeLabel),
            trailing: Text(l10n.comingSoonTitle),
          ),
        ],
      ),
    );
  }

  Future<void> _setBiometricLock(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    controller.setBiometricLockEnabled(value);
    if (!value) return;

    final l10n = AppLocalizations.of(context)!;
    final isAvailable = await ref
        .read(biometricAuthServiceProvider)
        .isAvailable();
    if (isAvailable || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsBiometricUnavailableMessage)),
    );
  }
}
