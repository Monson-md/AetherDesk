import 'package:aetherdesk/core/services/ai/ai_service.dart';
import 'package:aetherdesk/core/services/ai/ai_service_provider.dart';
import 'package:aetherdesk/core/services/ai/openai_compatible_ai_service.dart';
import 'package:aetherdesk/features/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import 'package:aetherdesk/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import 'package:aetherdesk/features/ai_assistant/domain/usecases/send_message_usecase.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wires the module's Clean Architecture layers together. Picks a real
/// [OpenAiCompatibleAiService] when the user has configured an endpoint in
/// Settings, falling back to `aiServiceProvider`'s `SimulatedAiService`
/// otherwise — nothing in `domain/`/`presentation/` needs to know which.
final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  final endpoint = settings.aiEndpointUrl;
  final AiService service = (endpoint == null || endpoint.isEmpty)
      ? ref.watch(aiServiceProvider)
      : OpenAiCompatibleAiService(
          baseUrl: endpoint,
          model: settings.aiModel ?? 'gpt-3.5-turbo',
          apiKey: settings.aiApiKey,
        );
  return AiAssistantRepositoryImpl(service);
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(aiAssistantRepositoryProvider));
});
