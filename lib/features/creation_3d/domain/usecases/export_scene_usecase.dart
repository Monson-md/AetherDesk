import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class ExportSceneUseCase {
  const ExportSceneUseCase(this._repository);

  final Creation3dRepository _repository;

  String call() {
    return _repository.exportSceneAsJson();
  }
}
