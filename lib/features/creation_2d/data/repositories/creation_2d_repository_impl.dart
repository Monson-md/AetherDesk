import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_layer.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

/// In-memory [Creation2dRepository]: holds the single open [Canvas2dProject]
/// for the lifetime of the app session. Real PNG export is a presentation
/// concern (it needs a `RenderRepaintBoundary`) — see
/// `creation_2d_home_page.dart`'s `_exportCanvas`.
class Creation2dRepositoryImpl implements Creation2dRepository {
  Canvas2dProject _project = Canvas2dProject.initial();
  int _nextLayerId = 2;

  @override
  Canvas2dProject getProject() => _project;

  List<Canvas2dLayer> _mapLayers(
    String layerId,
    Canvas2dLayer Function(Canvas2dLayer) transform,
  ) {
    return _project.layers
        .map((layer) => layer.id == layerId ? transform(layer) : layer)
        .toList();
  }

  @override
  Canvas2dProject addElement({
    required String layerId,
    required Canvas2dElement element,
  }) {
    _project = _project.copyWith(
      layers: _mapLayers(layerId, (layer) => layer.addElement(element)),
    );
    return _project;
  }

  @override
  Canvas2dProject undoLastElement({required String layerId}) {
    _project = _project.copyWith(
      layers: _mapLayers(layerId, (layer) => layer.removeLastElement()),
    );
    return _project;
  }

  @override
  Canvas2dProject addLayer({required String name}) {
    final layer = Canvas2dLayer(id: 'layer-${_nextLayerId++}', name: name);
    _project = _project.copyWith(layers: [..._project.layers, layer]);
    return _project;
  }

  @override
  Canvas2dProject updateLayer({
    required String layerId,
    String? name,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
  }) {
    _project = _project.copyWith(
      layers: _mapLayers(
        layerId,
        (layer) => layer.copyWith(
          name: name,
          isVisible: isVisible,
          isLocked: isLocked,
          opacity: opacity,
        ),
      ),
    );
    return _project;
  }

  @override
  Canvas2dProject deleteLayer(String layerId) {
    final remaining = _project.layers
        .where((layer) => layer.id != layerId)
        .toList();
    _project = _project.copyWith(
      layers: remaining.isEmpty
          ? [Canvas2dLayer(id: 'layer-${_nextLayerId++}', name: 'Calque 1')]
          : remaining,
    );
    return _project;
  }

  @override
  Canvas2dProject reorderLayers({
    required int oldIndex,
    required int newIndex,
  }) {
    final layers = [..._project.layers];
    final layer = layers.removeAt(oldIndex);
    layers.insert(newIndex, layer);
    _project = _project.copyWith(layers: layers);
    return _project;
  }

  @override
  Canvas2dProject clearLayer(String layerId) {
    _project = _project.copyWith(
      layers: _mapLayers(layerId, (layer) => layer.clearElements()),
    );
    return _project;
  }
}
