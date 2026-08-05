import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class AddSceneObjectUseCase {
  const AddSceneObjectUseCase(this._repository);

  final Creation3dRepository _repository;

  Creation3dProject call(SceneAsset asset) {
    return _repository.addObjectFromAsset(asset);
  }
}
