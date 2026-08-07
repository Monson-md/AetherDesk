import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:aetherdesk/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configures the real [AiService] used by `ai_assistant`: an
/// OpenAI-compatible `/chat/completions` endpoint (self-hosted Ollama/LM
/// Studio, OpenRouter, or any other provider speaking the same wire
/// format). Leaving the endpoint empty keeps `ai_assistant` on
/// `SimulatedAiService` — see `aiAssistantRepositoryProvider`.
class AiSection extends ConsumerStatefulWidget {
  const AiSection({super.key});

  @override
  ConsumerState<AiSection> createState() => _AiSectionState();
}

class _AiSectionState extends ConsumerState<AiSection> {
  late final _endpointController = TextEditingController(
    text: ref.read(settingsControllerProvider).aiEndpointUrl,
  );
  late final _modelController = TextEditingController(
    text: ref.read(settingsControllerProvider).aiModel,
  );
  late final _apiKeyController = TextEditingController(
    text: ref.read(settingsControllerProvider).aiApiKey,
  );
  bool _obscureKey = true;

  @override
  void dispose() {
    _endpointController.dispose();
    _modelController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isConfigured =
        ref.watch(settingsControllerProvider).aiEndpointUrl?.isNotEmpty ??
        false;

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
                isConfigured
                    ? l10n.settingsAiProviderCustomValue
                    : l10n.settingsAiProviderSimulatedValue,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          TextField(
            controller: _endpointController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l10n.settingsAiEndpointLabel,
              hintText: l10n.settingsAiEndpointHint,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          TextField(
            controller: _modelController,
            decoration: InputDecoration(
              labelText: l10n.settingsAiModelLabel,
              hintText: l10n.settingsAiModelHint,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
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
            onSubmitted: (_) => _save(),
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
            child: FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
          ),
        ],
      ),
    );
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(settingsControllerProvider.notifier);
    controller.setAiEndpointUrl(_endpointController.text);
    controller.setAiModel(_modelController.text);
    controller.setAiApiKey(_apiKeyController.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsAiApiKeySavedMessage)));
  }
}
