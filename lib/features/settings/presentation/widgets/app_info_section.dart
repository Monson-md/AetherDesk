import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/constants/app_version.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/updates/app_update_info.dart';
import 'package:aetherdesk/core/services/updates/app_update_service_provider.dart';
import 'package:aetherdesk/features/settings/presentation/providers/announcement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// App identity/version display, plus a real "check for updates" action
/// backed by `GithubAppUpdateService` (the public GitHub Releases API — no
/// account or paid plan needed).
class AppInfoSection extends ConsumerStatefulWidget {
  const AppInfoSection({super.key});

  @override
  ConsumerState<AppInfoSection> createState() => _AppInfoSectionState();
}

class _AppInfoSectionState extends ConsumerState<AppInfoSection> {
  bool _isChecking = false;
  AppUpdateInfo? _result;
  bool _checkFailed = false;

  Future<void> _checkForUpdate() async {
    setState(() {
      _isChecking = true;
      _checkFailed = false;
    });
    final result = await ref.read(appUpdateServiceProvider).checkForUpdate();
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _result = result;
      _checkFailed = result == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final result = _result;
    final announcement = ref.watch(announcementProvider).value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingSm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.campaign_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 18,
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Expanded(
                      child: Text(
                        announcement,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  l10n.settingsAppInfoTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text('AetherDesk', style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              '${l10n.settingsAppVersionLabel} $appVersion (${l10n.settingsAppBuildLabel} $appBuildNumber)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              l10n.settingsAppBuiltWith,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            OutlinedButton.icon(
              onPressed: _isChecking ? null : _checkForUpdate,
              icon: _isChecking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.system_update_outlined, size: 18),
              label: Text(l10n.settingsCheckForUpdateButton),
            ),
            if (_checkFailed) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.settingsUpdateCheckFailedMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            if (result != null && !result.isUpdateAvailable) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.settingsUpToDateMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            if (result != null && result.isUpdateAvailable) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.settingsUpdateAvailableMessage(result.latestVersion),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse(result.releaseUrl)),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(l10n.settingsOpenReleaseButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
