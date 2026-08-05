import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class RenderScenePreviewUseCase {
  const RenderScenePreviewUseCase(this._repository);

  final Creation3dRepository _repository;

  Future<String> call() {
    return _repository.renderPreview();
  }
}
