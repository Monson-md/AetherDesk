import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class UndoLastElementUseCase {
  const UndoLastElementUseCase(this._repository);

  final Creation2dRepository _repository;

  Canvas2dProject call({required String layerId}) {
    return _repository.undoLastElement(layerId: layerId);
  }
}
