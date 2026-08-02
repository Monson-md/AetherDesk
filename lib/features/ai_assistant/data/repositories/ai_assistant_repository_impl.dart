import 'package:aetherdesk/core/services/ai/ai_service.dart';
import 'package:aetherdesk/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

/// Adapts the module's [AiAssistantRepository] contract onto the app-wide
/// [AiService]. This is the seam: swap what `aiServiceProvider` resolves
/// to (simulated today, a real provider later) and this class — and
/// everything above it — stays exactly the same.
class AiAssistantRepositoryImpl implements AiAssistantRepository {
  const AiAssistantRepositoryImpl(this._aiService);

  final AiService _aiService;

  @override
  Stream<String> sendMessage(String prompt) =>
      _aiService.streamResponse(prompt);
}
