import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';

/// Module-level contract for managing the single in-memory 3D scene. There
/// is no persistence yet — every action mutates in-memory state only, ready
/// to be backed by a real project format later.
abstract interface class Creation3dRepository {
  Creation3dProject getProject();

  List<SceneAsset> getAssetLibrary();

  Creation3dProject addObjectFromAsset(SceneAsset asset);

  Creation3dProject updateObject({
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
  });

  Creation3dProject deleteObject(String objectId);

  Creation3dProject duplicateObject(String objectId);

  /// Delegates to the injected `SceneRenderService` swap point.
  Future<String> renderPreview();
}
