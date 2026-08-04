import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacySection extends ConsumerWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return SettingsSectionCard(
      title: l10n.settingsPrivacyTitle,
      icon: Icons.privacy_tip_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsAnalyticsLabel),
            value: settings.analyticsEnabled,
            onChanged: controller.setAnalyticsEnabled,
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            l10n.settingsPrivacyNote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
