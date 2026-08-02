import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_suggestion.dart';
import 'package:flutter/material.dart';

/// A single clickable starter suggestion on the chat empty state.
class ChatSuggestionCard extends StatelessWidget {
  const ChatSuggestionCard({
    required this.suggestion,
    required this.accentColor,
    required this.onTap,
    super.key,
  });

  final ChatSuggestion suggestion;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            child: Row(
              children: [
                Icon(suggestion.icon, color: accentColor, size: 22),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Text(
                    suggestion.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
