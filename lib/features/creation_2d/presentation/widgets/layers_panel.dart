import 'dart:async';

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_blend_mode.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_layer.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/canvas_tool_widgets.dart';
import 'package:flutter/material.dart';

/// Reorderable list of a [Canvas2dProject]'s layers, with per-layer
/// visibility/lock toggles, opacity slider, a real compositing blend-mode
/// picker, and a rename/duplicate/delete menu.
class LayersPanel extends StatelessWidget {
  const LayersPanel({
    required this.layers,
    required this.activeLayerId,
    required this.onLayerSelected,
    required this.onLayerAdded,
    required this.onLayerRenamed,
    required this.onLayerVisibilityChanged,
    required this.onLayerLockChanged,
    required this.onLayerOpacityChanged,
    required this.onLayerBlendModeChanged,
    required this.onLayerDuplicated,
    required this.onLayerDeleted,
    required this.onReorder,
    super.key,
  });

  final List<Canvas2dLayer> layers;
  final String activeLayerId;
  final ValueChanged<String> onLayerSelected;
  final VoidCallback onLayerAdded;
  final void Function(String layerId, String name) onLayerRenamed;
  final void Function(String layerId, bool isVisible) onLayerVisibilityChanged;
  final void Function(String layerId, bool isLocked) onLayerLockChanged;
  final void Function(String layerId, double opacity) onLayerOpacityChanged;
  final void Function(String layerId, Canvas2dBlendMode blendMode)
  onLayerBlendModeChanged;
  final ValueChanged<String> onLayerDuplicated;
  final ValueChanged<String> onLayerDeleted;
  final void Function(int oldIndex, int newIndex) onReorder;

  Future<void> _promptRename(BuildContext context, Canvas2dLayer layer) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: layer.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.creation2dRenameLayerTitle),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      onLayerRenamed(layer.id, name.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.creation2dLayersTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: l10n.creation2dAddLayer,
                onPressed: onLayerAdded,
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: layers.length,
            onReorderItem: onReorder,
            itemBuilder: (context, index) {
              final layer = layers[index];
              final isActive = layer.id == activeLayerId;
              return Card(
                key: ValueKey(layer.id),
                color: isActive
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSm,
                    vertical: AppDimensions.spacingXs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              layer.isVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => onLayerVisibilityChanged(
                              layer.id,
                              !layer.isVisible,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onLayerSelected(layer.id),
                              child: Text(
                                layer.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              layer.isLocked
                                  ? Icons.lock_outline
                                  : Icons.lock_open_outlined,
                              size: 20,
                            ),
                            onPressed: () =>
                                onLayerLockChanged(layer.id, !layer.isLocked),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) {
                              if (value == 'rename') {
                                unawaited(_promptRename(context, layer));
                              } else if (value == 'duplicate') {
                                onLayerDuplicated(layer.id);
                              } else if (value == 'delete') {
                                onLayerDeleted(layer.id);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'rename',
                                child: Text(l10n.commonRename),
                              ),
                              PopupMenuItem(
                                value: 'duplicate',
                                child: Text(l10n.creation2dDuplicateLayer),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(l10n.commonDelete),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: layer.opacity,
                              onChanged: (value) =>
                                  onLayerOpacityChanged(layer.id, value),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              '${(layer.opacity * 100).round()}%',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingXs,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Canvas2dBlendMode>(
                            value: layer.blendMode,
                            isDense: true,
                            isExpanded: true,
                            items: Canvas2dBlendMode.values
                                .map(
                                  (mode) => DropdownMenuItem(
                                    value: mode,
                                    child: Text(
                                      mode.label(l10n),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (mode) {
                              if (mode != null) {
                                onLayerBlendModeChanged(layer.id, mode);
                              }
                            },
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
      ],
    );
  }
}
