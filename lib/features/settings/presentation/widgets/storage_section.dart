import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';

/// The numbers shown here are illustrative placeholders, not read from any
/// real store — there is no `LocalStorageService` implementation yet (see
/// `core/services/storage/local_storage_service.dart`). "Clear cache" is
/// simulated: it has nothing real to delete.
class StorageSection extends StatelessWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SettingsSectionCard(
      title: l10n.settingsStorageTitle,
      icon: Icons.storage_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsStorageUsageLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: const LinearProgressIndicator(value: 0.12),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(l10n.settingsClearCacheButton),
              onPressed: () => _clearCache(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.settingsClearCacheConfirmTitle,
      message: l10n.settingsClearCacheConfirmMessage,
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (!confirmed || !context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsClearCacheDoneMessage)));
  }
}
