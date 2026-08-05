import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_layer.dart';

/// A 2D drawing project: a name plus an ordered stack of [Canvas2dLayer]s.
class Canvas2dProject {
  const Canvas2dProject({
    required this.id,
    required this.name,
    required this.layers,
  });

  factory Canvas2dProject.initial() => const Canvas2dProject(
    id: 'canvas-1',
    name: 'Sans titre',
    layers: [Canvas2dLayer(id: 'layer-1', name: 'Calque 1')],
  );

  final String id;
  final String name;
  final List<Canvas2dLayer> layers;

  int get elementCount =>
      layers.fold(0, (sum, layer) => sum + layer.elements.length);

  Canvas2dProject copyWith({String? name, List<Canvas2dLayer>? layers}) {
    return Canvas2dProject(
      id: id,
      name: name ?? this.name,
      layers: layers ?? this.layers,
    );
  }
}
