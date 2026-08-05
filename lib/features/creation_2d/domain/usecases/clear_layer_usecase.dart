import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class ClearLayerUseCase {
  const ClearLayerUseCase(this._repository);

  final Creation2dRepository _repository;

  Canvas2dProject call(String layerId) {
    return _repository.clearLayer(layerId);
  }
}
