import 'dart:async';
import 'dart:ui' as ui;

import 'package:aetherdesk/core/constants/app_dimensions.dart';
import 'package:aetherdesk/core/localization/generated/app_localizations.dart';
import 'package:aetherdesk/core/router/nav_destinations.dart';
import 'package:aetherdesk/core/router/route_paths.dart';
import 'package:aetherdesk/core/services/files/file_io_service_provider.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_point.dart';
import 'package:aetherdesk/features/creation_2d/presentation/providers/creation_2d_controller.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/creation_2d_toolbar.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/drawing_canvas.dart';
import 'package:aetherdesk/features/creation_2d/presentation/widgets/layers_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen of the `creation_2d` module: an interactive drawing canvas
/// with brushes, shapes, text and layers, backed by an in-memory
/// [Creation2dController]. Export ([_exportCanvas]) rasterizes the real
/// [RepaintBoundary] around the canvas and writes a real PNG via
/// `FileIoService` — no simulated output.
class Creation2dHomePage extends ConsumerStatefulWidget {
  const Creation2dHomePage({super.key});

  @override
  ConsumerState<Creation2dHomePage> createState() => _Creation2dHomePageState();
}

class _Creation2dHomePageState extends ConsumerState<Creation2dHomePage> {
  final _canvasBoundaryKey = GlobalKey();
  bool _isExporting = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _promptText(BuildContext context, CanvasPoint position) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.creation2dAddTextTitle),
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
    if (text != null && text.trim().isNotEmpty) {
      ref.read(creation2dControllerProvider.notifier).addText(text, position);
    }
  }

  Future<void> _exportCanvas() async {
    setState(() => _isExporting = true);
    try {
      final renderObject = _canvasBoundaryKey.currentContext
          ?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) return;
      final image = await renderObject.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final projectName = ref.read(creation2dControllerProvider).project.name;
      final saved = await ref
          .read(fileIoServiceProvider)
          .saveBinaryFile(
            suggestedName: '$projectName.png',
            bytes: byteData.buffer.asUint8List(),
          );
      if (!mounted || saved == null) return;
      _showMessage(
        AppLocalizations.of(context)!.creation2dExportedMessage(saved.fileName),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destination = destinationFor(l10n, RoutePaths.creation2d);
    final state = ref.watch(creation2dControllerProvider);
    final controller = ref.read(creation2dControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(destination.label)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          children: [
            Creation2dToolbar(
              activeTool: state.activeTool,
              onToolChanged: controller.selectTool,
              colorValue: state.colorValue,
              onColorChanged: controller.setColor,
              strokeWidth: state.strokeWidth,
              onStrokeWidthChanged: controller.setStrokeWidth,
              onUndo: controller.undo,
              onClearLayer: controller.clearActiveLayer,
              isExporting: _isExporting,
              onExport: _exportCanvas,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 800;
                  final canvas = Card(
                    clipBehavior: Clip.antiAlias,
                    child: RepaintBoundary(
                      key: _canvasBoundaryKey,
                      child: DrawingCanvas(
                        layers: state.project.layers,
                        activeTool: state.activeTool,
                        colorValue: state.colorValue,
                        strokeWidth: state.strokeWidth,
                        isActiveLayerLocked:
                            state.activeLayer?.isLocked ?? false,
                        onStrokeComplete: controller.addStroke,
                        onShapeComplete: controller.addShape,
                        onTextTap: (position) =>
                            unawaited(_promptText(context, position)),
                      ),
                    ),
                  );
                  final panel = LayersPanel(
                    layers: state.project.layers,
                    activeLayerId: state.activeLayerId,
                    onLayerSelected: controller.selectLayer,
                    onLayerAdded: () => controller.addLayer(
                      l10n.creation2dNewLayerName(
                        state.project.layers.length + 1,
                      ),
                    ),
                    onLayerRenamed: controller.renameLayer,
                    onLayerVisibilityChanged: (id, isVisible) => controller
                        .toggleLayerVisibility(id, isVisible: isVisible),
                    onLayerLockChanged: (id, isLocked) =>
                        controller.toggleLayerLock(id, isLocked: isLocked),
                    onLayerOpacityChanged: controller.setLayerOpacity,
                    onLayerDeleted: controller.deleteLayer,
                    onReorder: controller.reorderLayers,
                  );
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 3, child: canvas),
                        const SizedBox(width: AppDimensions.spacingMd),
                        SizedBox(width: 260, child: panel),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Expanded(flex: 3, child: canvas),
                      const SizedBox(height: AppDimensions.spacingMd),
                      Expanded(child: panel),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
