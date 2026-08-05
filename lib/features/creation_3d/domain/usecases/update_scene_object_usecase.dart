import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

class UpdateSceneObjectUseCase {
  const UpdateSceneObjectUseCase(this._repository);

  final Creation3dRepository _repository;

  Creation3dProject call({
    required String objectId,
    String? name,
    Vector3? position,
    Vector3? rotation,
    Vector3? scale,
    int? colorValue,
    MaterialPreset? material,
    bool? isVisible,
    bool? isLocked,
    double? lightIntensity,
    double? cameraFov,
  }) {
    return _repository.updateObject(
      objectId: objectId,
      name: name,
      position: position,
      rotation: rotation,
      scale: scale,
      colorValue: colorValue,
      material: material,
      isVisible: isVisible,
      isLocked: isLocked,
      lightIntensity: lightIntensity,
      cameraFov: cameraFov,
    );
  }
}
