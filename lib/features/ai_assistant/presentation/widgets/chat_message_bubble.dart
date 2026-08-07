import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/ai_assistant/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Renders one [ChatMessage] as a bubble, right-aligned and tinted with
/// the primary color for the user, left-aligned and neutral for the
/// assistant — with a discreet timestamp underneath.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isUser = message.role == ChatMessageRole.user;
    final bubbleColor = message.isError
        ? theme.colorScheme.errorContainer
        : isUser
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = message.isError
        ? theme.colorScheme.onErrorContainer
        : isUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.75,
            ),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppDimensions.radiusMd),
                      topRight: const Radius.circular(AppDimensions.radiusMd),
                      bottomLeft: Radius.circular(
                        isUser
                            ? AppDimensions.radiusMd
                            : AppDimensions.radiusSm,
                      ),
                      bottomRight: Radius.circular(
                        isUser
                            ? AppDimensions.radiusSm
                            : AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    message.isError ? l10n.chatErrorMessage : message.content,
                    softWrap: true,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  DateFormat.Hm().format(message.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
