import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_tool.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/canvas_tool_widgets.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/color_swatch_picker.dart';
import 'package:flutter/material.dart';

/// Top toolbar of the 2D creation workspace: tool palette, color picker,
/// brush size, undo/clear and export actions.
class Creation2dToolbar extends StatelessWidget {
  const Creation2dToolbar({
    required this.activeTool,
    required this.onToolChanged,
    required this.colorValue,
    required this.onColorChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.onUndo,
    required this.onClearLayer,
    required this.isExporting,
    required this.onExport,
    super.key,
  });

  final Canvas2dTool activeTool;
  final ValueChanged<Canvas2dTool> onToolChanged;
  final int colorValue;
  final ValueChanged<int> onColorChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final VoidCallback onUndo;
  final VoidCallback onClearLayer;
  final bool isExporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSm),
        child: Wrap(
          spacing: AppDimensions.spacingMd,
          runSpacing: AppDimensions.spacingSm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ToolPalette(activeTool: activeTool, onToolChanged: onToolChanged),
            ColorSwatchPicker(
              colorValue: colorValue,
              onColorChanged: onColorChanged,
            ),
            SizedBox(
              width: 160,
              child: Row(
                children: [
                  const Icon(Icons.line_weight_outlined, size: 18),
                  Expanded(
                    child: Slider(
                      value: strokeWidth,
                      min: 1,
                      max: 24,
                      onChanged: onStrokeWidthChanged,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.undo_outlined),
              tooltip: l10n.creation2dUndo,
              onPressed: onUndo,
            ),
            IconButton(
              icon: const Icon(Icons.layers_clear_outlined),
              tooltip: l10n.creation2dClearLayer,
              onPressed: onClearLayer,
            ),
            OutlinedButton.icon(
              icon: isExporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.ios_share_outlined),
              label: Text(l10n.creation2dExport),
              onPressed: isExporting ? null : onExport,
            ),
          ],
        ),
      ),
    );
  }
}
