/// Who authored a [ChatMessage].
enum ChatMessageRole { user, assistant }

/// A single message in an AI Assistant conversation.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isError = false,
  });

  final String id;
  final ChatMessageRole role;
  final String content;
  final DateTime timestamp;

  /// True when a real AI provider call failed while producing this
  /// message — `ChatMessageBubble` shows a localized error notice instead
  /// of [content] in that case.
  final bool isError;

  ChatMessage copyWith({String? content, bool? isError}) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
      isError: isError ?? this.isError,
    );
  }
}
