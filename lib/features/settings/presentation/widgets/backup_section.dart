import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// "Back up now" is simulated — see `SettingsController.simulateBackupNow`.
class BackupSection extends ConsumerWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastBackupAt = ref.watch(settingsControllerProvider).lastBackupAt;
    final controller = ref.read(settingsControllerProvider.notifier);

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
          Align(
            alignment: Alignment.centerLeft,
            child: PrimaryButton(
              label: l10n.settingsBackupButton,
              icon: Icons.cloud_upload_outlined,
              onPressed: () => _backupNow(context, controller),
            ),
          ),
        ],
      ),
    );
  }

  void _backupNow(BuildContext context, SettingsController controller) {
    final l10n = AppLocalizations.of(context)!;
    controller.simulateBackupNow();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsBackupSimulatedMessage)),
    );
  }
}
