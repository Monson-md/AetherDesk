import 'package:flutter/widgets.dart';

/// A starter suggestion shown on the empty-conversation screen. Tapping it
/// sends [prompt] as if the user had typed it.
class ChatSuggestion {
  const ChatSuggestion({
    required this.icon,
    required this.label,
    required this.prompt,
  });

  final IconData icon;
  final String label;
  final String prompt;
}
