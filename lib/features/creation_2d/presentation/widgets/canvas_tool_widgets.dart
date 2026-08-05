import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_tool.dart';
import 'package:flutter/material.dart';

/// Icon/label presentation for [Canvas2dTool], kept in `presentation/` since
/// the domain entity itself must stay free of Flutter imports.
extension Canvas2dToolPresentation on Canvas2dTool {
  IconData get icon => switch (this) {
    Canvas2dTool.select => Icons.near_me_outlined,
    Canvas2dTool.brush => Icons.brush_outlined,
    Canvas2dTool.eraser => Icons.auto_fix_off_outlined,
    Canvas2dTool.line => Icons.show_chart,
    Canvas2dTool.rectangle => Icons.crop_square_outlined,
    Canvas2dTool.ellipse => Icons.circle_outlined,
    Canvas2dTool.text => Icons.text_fields_outlined,
  };

  String label(AppLocalizations l10n) => switch (this) {
    Canvas2dTool.select => l10n.creation2dToolSelect,
    Canvas2dTool.brush => l10n.creation2dToolBrush,
    Canvas2dTool.eraser => l10n.creation2dToolEraser,
    Canvas2dTool.line => l10n.creation2dToolLine,
    Canvas2dTool.rectangle => l10n.creation2dToolRectangle,
    Canvas2dTool.ellipse => l10n.creation2dToolEllipse,
    Canvas2dTool.text => l10n.creation2dToolText,
  };
}

/// Row of selectable tool icons driving the active [Canvas2dTool].
class ToolPalette extends StatelessWidget {
  const ToolPalette({
    required this.activeTool,
    required this.onToolChanged,
    super.key,
  });

  final Canvas2dTool activeTool;
  final ValueChanged<Canvas2dTool> onToolChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 4,
      children: Canvas2dTool.values.map((tool) {
        final isActive = tool == activeTool;
        return Tooltip(
          message: tool.label(l10n),
          child: IconButton.filled(
            isSelected: isActive,
            style: IconButton.styleFrom(
              backgroundColor: isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
            ),
            icon: Icon(tool.icon),
            onPressed: () => onToolChanged(tool),
          ),
        );
      }).toList(),
    );
  }
}
