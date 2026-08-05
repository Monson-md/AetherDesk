import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class DuplicateSceneObjectUseCase {
  const DuplicateSceneObjectUseCase(this._repository);

  final Creation3dRepository _repository;

  Creation3dProject call(String objectId) {
    return _repository.duplicateObject(objectId);
  }
}
