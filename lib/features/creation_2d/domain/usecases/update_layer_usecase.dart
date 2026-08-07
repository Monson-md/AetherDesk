import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_blend_mode.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class UpdateLayerUseCase {
  const UpdateLayerUseCase(this._repository);

  final Creation2dRepository _repository;

  Canvas2dProject call({
    required String layerId,
    String? name,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    Canvas2dBlendMode? blendMode,
  }) {
    return _repository.updateLayer(
      layerId: layerId,
      name: name,
      isVisible: isVisible,
      isLocked: isLocked,
      opacity: opacity,
      blendMode: blendMode,
    );
  }
}
