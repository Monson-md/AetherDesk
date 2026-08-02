/// Who authored a [ChatMessage].
enum ChatMessageRole { user, assistant }

/// A single message in an AI Assistant conversation.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String id;
  final ChatMessageRole role;
  final String content;
  final DateTime timestamp;

  ChatMessage copyWith({String? content}) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
    );
  }
}
