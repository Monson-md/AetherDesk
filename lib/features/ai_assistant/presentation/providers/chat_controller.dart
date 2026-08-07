import 'package:aetherdesk/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/providers/ai_assistant_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Snapshot of the current conversation with the assistant.
class ChatState {
  const ChatState({this.messages = const [], this.isAssistantThinking = false});

  final List<ChatMessage> messages;

  /// True from the moment a prompt is sent until the first chunk of the
  /// reply arrives — the UI shows a "thinking" indicator during this
  /// window instead of an empty assistant bubble.
  final bool isAssistantThinking;

  ChatState copyWith({List<ChatMessage>? messages, bool? isAssistantThinking}) {
    return ChatState(
      messages: messages ?? this.messages,
      isAssistantThinking: isAssistantThinking ?? this.isAssistantThinking,
    );
  }
}

/// Owns the conversation for the AI Assistant module. Talks only to
/// [SendMessageUseCase] — it has no idea whether replies are simulated or
/// come from a real model, so nothing here changes when one replaces the
/// other.
class ChatController extends Notifier<ChatState> {
  int _idCounter = 0;

  @override
  ChatState build() => const ChatState();

  Future<void> sendMessage(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty || state.isAssistantThinking) return;

    state = state.copyWith(
      messages: [...state.messages, _newMessage(ChatMessageRole.user, text)],
      isAssistantThinking: true,
    );

    final sendMessage = ref.read(sendMessageUseCaseProvider);
    String? assistantMessageId;

    try {
      await for (final chunk in sendMessage(text)) {
        if (assistantMessageId == null) {
          final assistantMessage = _newMessage(
            ChatMessageRole.assistant,
            chunk,
          );
          assistantMessageId = assistantMessage.id;
          state = state.copyWith(
            messages: [...state.messages, assistantMessage],
            isAssistantThinking: false,
          );
        } else {
          final id = assistantMessageId;
          state = state.copyWith(
            messages: [
              for (final message in state.messages)
                if (message.id == id)
                  message.copyWith(content: message.content + chunk)
                else
                  message,
            ],
          );
        }
      }
    } on Exception {
      _markAsError(assistantMessageId);
    }
  }

  /// A real AI provider call can fail (bad endpoint, network, wrong model)
  /// where `SimulatedAiService` never did — surface it as an error bubble
  /// instead of leaving the "thinking" indicator stuck or crashing.
  void _markAsError(String? assistantMessageId) {
    if (assistantMessageId == null) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          _newMessage(ChatMessageRole.assistant, '').copyWith(isError: true),
        ],
        isAssistantThinking: false,
      );
      return;
    }
    state = state.copyWith(
      messages: [
        for (final message in state.messages)
          if (message.id == assistantMessageId)
            message.copyWith(isError: true)
          else
            message,
      ],
      isAssistantThinking: false,
    );
  }

  ChatMessage _newMessage(ChatMessageRole role, String content) {
    return ChatMessage(
      id: 'msg_${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}',
      role: role,
      content: content,
      timestamp: DateTime.now(),
    );
  }
}

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);
