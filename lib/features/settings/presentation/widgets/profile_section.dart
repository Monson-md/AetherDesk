import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/widgets/core_widgets.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local-only display name editor. Not connected to the separate
/// `user_profile` module (which stays a placeholder) — this is purely a
/// `settings` preference, in memory only.
class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final displayName = ref.watch(settingsControllerProvider).displayName;
    final initial = displayName.isEmpty
        ? '?'
        : displayName.substring(0, 1).toUpperCase();

    return SettingsSectionCard(
      title: l10n.settingsProfileTitle,
      icon: Icons.person_outline,
      child: Row(
        children: [
          CircleAvatar(radius: 24, child: Text(initial)),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Text(
              displayName.isEmpty ? l10n.settingsNoDisplayName : displayName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.settingsEditDisplayNameTooltip,
            onPressed: () => _editDisplayName(context, ref, displayName),
          ),
        ],
      ),
    );
  }

  Future<void> _editDisplayName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsDisplayNameLabel),
        content: AppTextField(
          label: l10n.settingsDisplayNameHint,
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    ref.read(settingsControllerProvider.notifier).setDisplayName(result);
  }
}
