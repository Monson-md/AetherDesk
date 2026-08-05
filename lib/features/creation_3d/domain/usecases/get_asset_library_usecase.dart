import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class GetAssetLibraryUseCase {
  const GetAssetLibraryUseCase(this._repository);

  final Creation3dRepository _repository;

  List<SceneAsset> call() {
    return _repository.getAssetLibrary();
  }
}
