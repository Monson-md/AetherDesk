import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Kept in sync by hand with `pubspec.yaml`'s `version:` line — this app
/// has no `package_info_plus` dependency to read it at runtime, and adding
/// one just for this static display isn't worth it.
const String _appVersion = '1.0.0';
const String _appBuildNumber = '1';

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              '${l10n.settingsAppVersionLabel} $_appVersion (${l10n.settingsAppBuildLabel} $_appBuildNumber)',
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
          ],
        ),
      ),
    );
  }
}
