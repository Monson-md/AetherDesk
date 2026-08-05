import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_element.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_project.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class AddCanvasElementUseCase {
  const AddCanvasElementUseCase(this._repository);

  final Creation2dRepository _repository;

  Canvas2dProject call({
    required String layerId,
    required Canvas2dElement element,
  }) {
    return _repository.addElement(layerId: layerId, element: element);
  }
}
