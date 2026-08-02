import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Bottom composer: a rounded multiline text field with a send button.
/// Stateless — the controller is owned by the page so its lifecycle is
/// managed in exactly one place.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.hintText,
    required this.sendTooltip,
    required this.enabled,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;
  final String sendTooltip;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Material(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingXs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 140),
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => onSend(),
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingSm,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                IconButton.filled(
                  tooltip: sendTooltip,
                  onPressed: enabled ? onSend : null,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
