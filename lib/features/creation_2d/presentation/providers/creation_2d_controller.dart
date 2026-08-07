import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_blend_mode.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_layer.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_point.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_tool.dart';
import 'package:aetherdesk/features/creation_2d/presentation/providers/creation_2d_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State of the 2D creation workspace: the current project plus the active
/// tool/color/stroke settings used by [DrawingCanvas] to build new elements.
class Creation2dState {
  const Creation2dState({
    required this.project,
    required this.activeLayerId,
    this.activeTool = Canvas2dTool.brush,
    this.colorValue = 0xFF1A1A1A,
    this.strokeWidth = 4,
  });

  final Canvas2dProject project;
  final String activeLayerId;
  final Canvas2dTool activeTool;
  final int colorValue;
  final double strokeWidth;

  Canvas2dLayer? get activeLayer {
    for (final layer in project.layers) {
      if (layer.id == activeLayerId) return layer;
    }
    return null;
  }

  Creation2dState copyWith({
    Canvas2dProject? project,
    String? activeLayerId,
    Canvas2dTool? activeTool,
    int? colorValue,
    double? strokeWidth,
  }) {
    return Creation2dState(
      project: project ?? this.project,
      activeLayerId: activeLayerId ?? this.activeLayerId,
      activeTool: activeTool ?? this.activeTool,
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

/// Holds the 2D creation workspace state and wires user actions to the
/// `Creation2dRepository` usecases. PNG export lives in
/// `creation_2d_home_page.dart` instead of here — it needs a
/// `RenderRepaintBoundary`, which is a presentation-layer concept.
class Creation2dController extends Notifier<Creation2dState> {
  int _nextElementId = 1;

  @override
  Creation2dState build() {
    final project = ref.read(creation2dRepositoryProvider).getProject();
    return Creation2dState(
      project: project,
      activeLayerId: project.layers.first.id,
    );
  }

  String _newElementId() => 'element-${_nextElementId++}';

  void selectTool(Canvas2dTool tool) {
    state = state.copyWith(activeTool: tool);
  }

  void setColor(int colorValue) {
    state = state.copyWith(colorValue: colorValue);
  }

  void setStrokeWidth(double width) {
    state = state.copyWith(strokeWidth: width);
  }

  void selectLayer(String layerId) {
    state = state.copyWith(activeLayerId: layerId);
  }

  void addStroke(List<CanvasPoint> points, {required bool isEraser}) {
    if (points.isEmpty) return;
    final element = StrokeElement(
      id: _newElementId(),
      colorValue: state.colorValue,
      strokeWidth: state.strokeWidth,
      points: points,
      isEraser: isEraser,
    );
    final project = ref
        .read(addCanvasElementUseCaseProvider)
        .call(layerId: state.activeLayerId, element: element);
    state = state.copyWith(project: project);
  }

  void addShape(CanvasPoint start, CanvasPoint end) {
    final element = ShapeElement(
      id: _newElementId(),
      colorValue: state.colorValue,
      strokeWidth: state.strokeWidth,
      shapeType: state.activeTool.asShapeType ?? Canvas2dShapeType.rectangle,
      start: start,
      end: end,
    );
    final project = ref
        .read(addCanvasElementUseCaseProvider)
        .call(layerId: state.activeLayerId, element: element);
    state = state.copyWith(project: project);
  }

  void addText(String text, CanvasPoint position) {
    if (text.trim().isEmpty) return;
    final element = TextElement2d(
      id: _newElementId(),
      colorValue: state.colorValue,
      text: text,
      position: position,
      fontSize: 12 + state.strokeWidth * 2,
    );
    final project = ref
        .read(addCanvasElementUseCaseProvider)
        .call(layerId: state.activeLayerId, element: element);
    state = state.copyWith(project: project);
  }

  void undo() {
    final project = ref
        .read(undoLastElementUseCaseProvider)
        .call(layerId: state.activeLayerId);
    state = state.copyWith(project: project);
  }

  void addLayer(String name) {
    final project = ref.read(addLayerUseCaseProvider).call(name: name);
    state = state.copyWith(
      project: project,
      activeLayerId: project.layers.last.id,
    );
  }

  void renameLayer(String layerId, String name) {
    final project = ref
        .read(updateLayerUseCaseProvider)
        .call(layerId: layerId, name: name);
    state = state.copyWith(project: project);
  }

  void toggleLayerVisibility(String layerId, {required bool isVisible}) {
    final project = ref
        .read(updateLayerUseCaseProvider)
        .call(layerId: layerId, isVisible: isVisible);
    state = state.copyWith(project: project);
  }

  void toggleLayerLock(String layerId, {required bool isLocked}) {
    final project = ref
        .read(updateLayerUseCaseProvider)
        .call(layerId: layerId, isLocked: isLocked);
    state = state.copyWith(project: project);
  }

  void setLayerOpacity(String layerId, double opacity) {
    final project = ref
        .read(updateLayerUseCaseProvider)
        .call(layerId: layerId, opacity: opacity);
    state = state.copyWith(project: project);
  }

  void setLayerBlendMode(String layerId, Canvas2dBlendMode blendMode) {
    final project = ref
        .read(updateLayerUseCaseProvider)
        .call(layerId: layerId, blendMode: blendMode);
    state = state.copyWith(project: project);
  }

  void duplicateLayer(String layerId) {
    final project = ref.read(duplicateLayerUseCaseProvider).call(layerId);
    state = state.copyWith(project: project);
  }

  void deleteLayer(String layerId) {
    final project = ref.read(deleteLayerUseCaseProvider).call(layerId);
    final stillExists = project.layers.any((l) => l.id == state.activeLayerId);
    state = state.copyWith(
      project: project,
      activeLayerId: stillExists
          ? state.activeLayerId
          : project.layers.first.id,
    );
  }

  void reorderLayers(int oldIndex, int newIndex) {
    final project = ref
        .read(reorderLayersUseCaseProvider)
        .call(oldIndex: oldIndex, newIndex: newIndex);
    state = state.copyWith(project: project);
  }

  void clearActiveLayer() {
    final project = ref
        .read(clearLayerUseCaseProvider)
        .call(state.activeLayerId);
    state = state.copyWith(project: project);
  }
}

final creation2dControllerProvider =
    NotifierProvider<Creation2dController, Creation2dState>(
      Creation2dController.new,
    );
