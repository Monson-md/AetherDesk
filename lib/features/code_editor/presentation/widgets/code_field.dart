import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/features/code_editor/presentation/providers/code_editor_providers.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/code_token_colors.dart';
import 'package:aetherdesk/features/code_editor/presentation/widgets/highlighting_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _gutterWidth = 52;

/// Professional code editing zone (requirements #1-4): monospace text,
/// line-number gutter kept in sync by disabling line wrapping (one logical
/// line = one visual line), and simulated syntax highlighting driven by
/// [HighlightingTextEditingController].
class CodeField extends ConsumerStatefulWidget {
  const CodeField({
    required this.content,
    required this.language,
    required this.onChanged,
    super.key,
  });

  final String content;
  final CodeLanguage language;
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<CodeField> createState() => CodeFieldState();
}

/// Public so the home page can hold a `GlobalKey<CodeFieldState>` and drive
/// real in-document search ([updateSearch]/[nextMatch]/[previousMatch])
/// without this widget needing to expose its [TextEditingController].
class CodeFieldState extends ConsumerState<CodeField> {
  late final HighlightingTextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  List<int> _matchOffsets = const [];
  int _currentMatchIndex = -1;
  String _query = '';

  int get matchCount => _matchOffsets.length;
  int get currentMatchIndex => _currentMatchIndex;

  /// Recomputes every case-insensitive occurrence of [query] in the current
  /// text and jumps to the first one. Returns the match count.
  int updateSearch(String query) {
    _query = query;
    if (query.isEmpty) {
      setState(() {
        _matchOffsets = const [];
        _currentMatchIndex = -1;
      });
      return 0;
    }
    final text = _controller.text.toLowerCase();
    final needle = query.toLowerCase();
    final offsets = <int>[];
    var start = 0;
    while (true) {
      final index = text.indexOf(needle, start);
      if (index == -1) break;
      offsets.add(index);
      start = index + needle.length;
    }
    setState(() {
      _matchOffsets = offsets;
      _currentMatchIndex = offsets.isEmpty ? -1 : 0;
    });
    _jumpToCurrentMatch();
    return offsets.length;
  }

  void nextMatch() {
    if (_matchOffsets.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _matchOffsets.length;
    });
    _jumpToCurrentMatch();
  }

  void previousMatch() {
    if (_matchOffsets.isEmpty) return;
    setState(() {
      _currentMatchIndex =
          (_currentMatchIndex - 1 + _matchOffsets.length) %
          _matchOffsets.length;
    });
    _jumpToCurrentMatch();
  }

  void _jumpToCurrentMatch() {
    if (_currentMatchIndex == -1) return;
    final offset = _matchOffsets[_currentMatchIndex];
    _controller.selection = TextSelection(
      baseOffset: offset,
      extentOffset: offset + _query.length,
    );
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _controller = HighlightingTextEditingController(
      text: widget.content,
      language: widget.language,
      tokenize: ({required code, required language}) => ref.read(
        highlightCodeUseCaseProvider,
      )(code: code, language: language),
      colorForType: (type) =>
          colorForCodeToken(type, Theme.of(context).colorScheme),
    )..addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (_controller.text != widget.content) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void didUpdateWidget(covariant CodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != _controller.text) {
      final selection = _controller.selection;
      _controller.value = _controller.value.copyWith(
        text: widget.content,
        selection:
            selection.start <= widget.content.length &&
                selection.end <= widget.content.length
            ? selection
            : TextSelection.collapsed(offset: widget.content.length),
        composing: TextRange.empty,
      );
    }
    _controller.language = widget.language;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final codeStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      height: 1.6,
      color: colorScheme.onSurface,
    );
    final lineCount = widget.content.isEmpty
        ? 1
        : '\n'.allMatches(widget.content).length + 1;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minCodeWidth =
                constraints.maxWidth -
                _gutterWidth -
                1 -
                AppDimensions.spacingMd * 2;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingMd,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LineNumberGutter(
                      lineCount: lineCount,
                      style: codeStyle,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: minCodeWidth.clamp(0, double.infinity),
                          ),
                          child: IntrinsicWidth(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingMd,
                              ),
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                maxLines: null,
                                style: codeStyle,
                                cursorColor: colorScheme.primary,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintText: l10n.codeEditorEmptyHint,
                                  hintStyle: codeStyle.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LineNumberGutter extends StatelessWidget {
  const _LineNumberGutter({
    required this.lineCount,
    required this.style,
    required this.color,
  });

  final int lineCount;
  final TextStyle style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _gutterWidth,
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var line = 1; line <= lineCount; line++)
              Text('$line', style: style.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
