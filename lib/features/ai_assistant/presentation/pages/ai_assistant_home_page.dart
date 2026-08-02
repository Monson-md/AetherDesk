import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/widgets/layout/responsive_content_wrapper.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/providers/chat_controller.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_empty_state.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_input_bar.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_message_bubble.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_suggestion.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_thinking_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `ai_assistant` module: a premium chat interface with
/// a simulated assistant. See `SimulatedAiService` / `aiServiceProvider`
/// for the seam where a real AI provider plugs in later without touching
/// anything in this file.
class AiAssistantHomePage extends ConsumerStatefulWidget {
  const AiAssistantHomePage({super.key});

  @override
  ConsumerState<AiAssistantHomePage> createState() =>
      _AiAssistantHomePageState();
}

class _AiAssistantHomePageState extends ConsumerState<AiAssistantHomePage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? presetPrompt]) {
    final text = presetPrompt ?? _inputController.text;
    if (text.trim().isEmpty) return;
    ref.read(chatControllerProvider.notifier).sendMessage(text);
    _inputController.clear();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  List<ChatSuggestion> _buildSuggestions(AppLocalizations l10n) {
    return [
      ChatSuggestion(
        icon: Icons.code,
        label: l10n.chatSuggestionGenerateCode,
        prompt: l10n.chatSuggestionGenerateCode,
      ),
      ChatSuggestion(
        icon: Icons.bug_report_outlined,
        label: l10n.chatSuggestionDebug,
        prompt: l10n.chatSuggestionDebug,
      ),
      ChatSuggestion(
        icon: Icons.lightbulb_outline,
        label: l10n.chatSuggestionExplain,
        prompt: l10n.chatSuggestionExplain,
      ),
      ChatSuggestion(
        icon: Icons.event_note_outlined,
        label: l10n.chatSuggestionPlan,
        prompt: l10n.chatSuggestionPlan,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.aiAssistant);
    final chatState = ref.watch(chatControllerProvider);

    ref.listen(chatControllerProvider, (previous, next) {
      final messagesGrew =
          previous == null || next.messages.length != previous.messages.length;
      final thinkingChanged =
          previous?.isAssistantThinking != next.isAssistantThinking;
      if (messagesGrew || thinkingChanged) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    final hasMessages = chatState.messages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: Column(
        children: [
          Expanded(
            child: hasMessages
                ? ResponsiveContentWrapper(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          chatState.messages.length +
                          (chatState.isAssistantThinking ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chatState.messages.length) {
                          return const ChatThinkingIndicator();
                        }
                        return ChatMessageBubble(
                          message: chatState.messages[index],
                        );
                      },
                    ),
                  )
                : ChatEmptyState(
                    accentColor: destination.color,
                    icon: destination.icon,
                    title: l10n.chatEmptyTitle,
                    message: l10n.chatEmptyMessage,
                    suggestions: _buildSuggestions(l10n),
                    onSuggestionTap: _send,
                  ),
          ),
          ResponsiveContentWrapper(
            child: ChatInputBar(
              controller: _inputController,
              onSend: _send,
              hintText: l10n.chatInputHint,
              sendTooltip: l10n.chatSendTooltip,
              enabled: !chatState.isAssistantThinking,
            ),
          ),
        ],
      ),
    );
  }
}
