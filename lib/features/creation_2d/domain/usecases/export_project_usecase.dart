import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';

class ExportProjectUseCase {
  const ExportProjectUseCase(this._repository);

  final Creation2dRepository _repository;

  Future<String> call() {
    return _repository.exportProject();
  }
}
