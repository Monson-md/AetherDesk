import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Live line/character/word counters (requirement #8).
class CodeEditorStatsBar extends StatelessWidget {
  const CodeEditorStatsBar({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final lines = content.isEmpty ? 0 : '\n'.allMatches(content).length + 1;
    final chars = content.length;
    final words = content.trim().isEmpty
        ? 0
        : content.trim().split(RegExp(r'\s+')).length;

    return Wrap(
      spacing: AppDimensions.spacingLg,
      runSpacing: AppDimensions.spacingXs,
      children: [
        Text(l10n.codeEditorLinesCount(lines), style: style),
        Text(l10n.codeEditorCharsCount(chars), style: style),
        Text(l10n.codeEditorWordsCount(words), style: style),
      ],
    );
  }
}
