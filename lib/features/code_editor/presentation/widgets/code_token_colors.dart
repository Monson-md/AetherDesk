import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:flutter/material.dart';

/// Maps a [CodeTokenType] to a color drawn from AetherDesk's existing module
/// accent palette (see `core/router/nav_destinations.dart`), so highlighted
/// code reads as part of the same design system rather than a bolted-on
/// generic editor theme.
Color colorForCodeToken(CodeTokenType type, ColorScheme colorScheme) {
  switch (type) {
    case CodeTokenType.keyword:
      return const Color(0xFF7C6FF0);
    case CodeTokenType.string:
      return const Color(0xFF22C55E);
    case CodeTokenType.number:
      return const Color(0xFFC9962B);
    case CodeTokenType.type:
      return const Color(0xFF00B8A9);
    case CodeTokenType.comment:
      return colorScheme.onSurfaceVariant;
    case CodeTokenType.punctuation:
      return colorScheme.onSurfaceVariant;
    case CodeTokenType.plain:
      return colorScheme.onSurface;
  }
}
