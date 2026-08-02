import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_suggestion.dart';
import 'package:aetherdesk/features/ai_assistant/presentation/widgets/chat_suggestion_card.dart';
import 'package:flutter/material.dart';

/// Elegant welcome screen shown before the first message is sent: a
/// tinted icon badge, a greeting, and a set of clickable starter
/// suggestions.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.message,
    required this.suggestions,
    required this.onSuggestionTap,
    super.key,
  });

  final Color accentColor;
  final IconData icon;
  final String title;
  final String message;
  final List<ChatSuggestion> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: accentColor),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            Wrap(
              spacing: AppDimensions.spacingMd,
              runSpacing: AppDimensions.spacingMd,
              alignment: WrapAlignment.center,
              children: [
                for (final suggestion in suggestions)
                  ChatSuggestionCard(
                    suggestion: suggestion,
                    accentColor: accentColor,
                    onTap: () => onSuggestionTap(suggestion.prompt),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
