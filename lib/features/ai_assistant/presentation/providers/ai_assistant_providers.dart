import 'package:aetherdesk/core/services/ai/ai_service_provider.dart';
import 'package:aetherdesk/features/ai_assistant/data/repositories/ai_assistant_repository_impl.dart';
import 'package:aetherdesk/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';
import 'package:aetherdesk/features/ai_assistant/domain/usecases/send_message_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wires the module's Clean Architecture layers together. Each provider
/// depends only on the abstraction below it, so `aiServiceProvider` is the
/// only thing that needs to change to plug in a real AI provider.
final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  return AiAssistantRepositoryImpl(ref.watch(aiServiceProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(aiAssistantRepositoryProvider));
});
