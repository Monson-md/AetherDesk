import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/providers/cloud_backup_providers.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Real Firestore-backed backup/restore of the profile — see
/// `CloudBackupController`. Requires the optional Firebase account from
/// `CloudAccountSection` on the Profile page.
class BackupSection extends ConsumerWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastBackupAt = ref.watch(settingsControllerProvider).lastBackupAt;
    final isBusy = ref.watch(cloudBackupControllerProvider).isLoading;

    return SettingsSectionCard(
      title: l10n.settingsBackupTitle,
      icon: Icons.backup_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lastBackupAt == null
                ? l10n.settingsBackupNeverLabel
                : l10n.settingsBackupLastLabel(
                    DateFormat.yMMMd().add_Hm().format(lastBackupAt),
                  ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: [
              PrimaryButton(
                label: l10n.settingsBackupButton,
                icon: Icons.cloud_upload_outlined,
                isLoading: isBusy,
                onPressed: isBusy ? null : () => _backupNow(context, ref),
              ),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => _restoreNow(context, ref),
                icon: const Icon(Icons.cloud_download_outlined, size: 18),
                label: Text(l10n.settingsRestoreButton),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _backupNow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(cloudBackupControllerProvider.notifier)
        .backupNow();
    if (!context.mounted) return;
    final message = switch (result) {
      CloudBackupResult.success => l10n.settingsBackupSuccessMessage,
      CloudBackupResult.notSignedIn => l10n.settingsBackupSignInRequiredMessage,
      CloudBackupResult.notFound ||
      CloudBackupResult.failure => l10n.settingsBackupFailedMessage,
    };
    if (result == CloudBackupResult.success) {
      ref.read(settingsControllerProvider.notifier).markBackedUpNow();
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _restoreNow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(cloudBackupControllerProvider.notifier)
        .restoreNow();
    if (!context.mounted) return;
    final message = switch (result) {
      CloudBackupResult.success => l10n.settingsRestoreSuccessMessage,
      CloudBackupResult.notSignedIn => l10n.settingsBackupSignInRequiredMessage,
      CloudBackupResult.notFound => l10n.settingsRestoreNotFoundMessage,
      CloudBackupResult.failure => l10n.settingsBackupFailedMessage,
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
