import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `ai_assistant` still runs entirely on `SimulatedAiService` — this field
/// only stores a key in memory (never logged, never sent anywhere) for the
/// day a real provider is wired in behind `AiService`, per `ROADMAP.md`.
class AiSection extends ConsumerStatefulWidget {
  const AiSection({super.key});

  @override
  ConsumerState<AiSection> createState() => _AiSectionState();
}

class _AiSectionState extends ConsumerState<AiSection> {
  late final _apiKeyController = TextEditingController(
    text: ref.read(settingsControllerProvider).aiApiKey,
  );
  bool _obscureKey = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SettingsSectionCard(
      title: l10n.settingsAiTitle,
      icon: Icons.smart_toy_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.settingsAiProviderLabel,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                l10n.settingsAiProviderValue,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureKey,
            decoration: InputDecoration(
              labelText: l10n.settingsAiApiKeyLabel,
              hintText: l10n.settingsAiApiKeyHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureKey
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscureKey = !_obscureKey),
              ),
            ),
            onSubmitted: (_) => _saveKey(),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            l10n.settingsAiApiKeyNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: _saveKey,
              child: Text(l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }

  void _saveKey() {
    final l10n = AppLocalizations.of(context)!;
    ref
        .read(settingsControllerProvider.notifier)
        .setAiApiKey(_apiKeyController.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsAiApiKeySavedMessage)));
  }
}
