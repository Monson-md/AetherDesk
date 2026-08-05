import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class ReorderLayersUseCase {
  const ReorderLayersUseCase(this._repository);

  final Creation2dRepository _repository;

  Canvas2dProject call({required int oldIndex, required int newIndex}) {
    return _repository.reorderLayers(oldIndex: oldIndex, newIndex: newIndex);
  }
}
