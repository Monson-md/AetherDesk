import 'package:aetherdesk/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

/// Sends a single prompt to the assistant. Kept thin on purpose — it
/// exists so `presentation/` depends on an intention ("send a message")
/// rather than on the repository directly.
class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final AiAssistantRepository _repository;

  Stream<String> call(String prompt) => _repository.sendMessage(prompt);
}
