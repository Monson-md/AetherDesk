import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_blend_mode.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';

/// Module-level contract for managing the single in-memory 2D drawing
/// project. There is no persistence yet — every action mutates in-memory
/// state only, ready to be backed by real file I/O later.
abstract interface class Creation2dRepository {
  Canvas2dProject getProject();

  Canvas2dProject addElement({
    required String layerId,
    required Canvas2dElement element,
  });

  Canvas2dProject undoLastElement({required String layerId});

  Canvas2dProject addLayer({required String name});

  Canvas2dProject updateLayer({
    required String layerId,
    String? name,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    Canvas2dBlendMode? blendMode,
  });

  Canvas2dProject deleteLayer(String layerId);

  Canvas2dProject duplicateLayer(String layerId);

  Canvas2dProject reorderLayers({required int oldIndex, required int newIndex});

  Canvas2dProject clearLayer(String layerId);
}
