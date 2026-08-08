import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/storage/app_storage_usage_service_provider.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/providers/storage_usage_provider.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _formatBytes(int bytes) {
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)} MB';
  if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(1)} KB';
  return '$bytes B';
}

/// Real on-disk usage of the app's own documents/support/temporary
/// directories (see `AppStorageUsageService`) and a real "Clear cache" that
/// deletes the temporary directory's contents.
class StorageSection extends ConsumerWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final usage = ref.watch(storageUsageBytesProvider);

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
          usage.when(
            data: (bytes) =>
                Text(_formatBytes(bytes), style: theme.textTheme.titleMedium),
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, stackTrace) =>
                Text(l10n.settingsStorageErrorMessage),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.delete_sweep_outlined),
              label: Text(l10n.settingsClearCacheButton),
              onPressed: () => _clearCache(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.settingsClearCacheConfirmTitle,
      message: l10n.settingsClearCacheConfirmMessage,
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(appStorageUsageServiceProvider).clearCache();
    ref.invalidate(storageUsageBytesProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsClearCacheDoneMessage)));
  }
}
