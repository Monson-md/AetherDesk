import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Assistant-side "thinking" bubble shown while waiting for the first
/// chunk of a reply — mirrors the latency of a real streaming AI call.
class ChatThinkingIndicator extends StatefulWidget {
  const ChatThinkingIndicator({super.key});

  @override
  State<ChatThinkingIndicator> createState() => _ChatThinkingIndicatorState();
}

class _ChatThinkingIndicatorState extends State<ChatThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingSm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                topRight: Radius.circular(AppDimensions.radiusMd),
                bottomRight: Radius.circular(AppDimensions.radiusMd),
                bottomLeft: Radius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.chatThinking, style: theme.textTheme.bodySmall),
                const SizedBox(width: AppDimensions.spacingSm),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final t = (_controller.value - i * 0.2) % 1.0;
                        final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(
                          0.25,
                          1.0,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurfaceVariant,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
