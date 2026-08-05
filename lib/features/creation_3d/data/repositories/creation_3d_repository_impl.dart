import 'package:aetherdesk/core/services/graphics_3d/scene_render_service.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';

const _assetLibrary = [
  SceneAsset(id: 'asset-cube', name: 'Cube', type: SceneObjectType.cube),
  SceneAsset(id: 'asset-sphere', name: 'Sphère', type: SceneObjectType.sphere),
  SceneAsset(
    id: 'asset-cylinder',
    name: 'Cylindre',
    type: SceneObjectType.cylinder,
  ),
  SceneAsset(id: 'asset-cone', name: 'Cône', type: SceneObjectType.cone),
  SceneAsset(id: 'asset-plane', name: 'Plan', type: SceneObjectType.plane),
  SceneAsset(
    id: 'asset-light',
    name: 'Lumière ponctuelle',
    type: SceneObjectType.light,
  ),
  SceneAsset(id: 'asset-camera', name: 'Caméra', type: SceneObjectType.camera),
];

/// In-memory [Creation3dRepository]: holds the single open
/// [Creation3dProject] for the lifetime of the app session. Preview
/// rendering is delegated to the injected [SceneRenderService] swap point.
class Creation3dRepositoryImpl implements Creation3dRepository {
  Creation3dRepositoryImpl(this._renderService);

  final SceneRenderService _renderService;
  Creation3dProject _project = Creation3dProject.initial();
  int _nextObjectId = 4;

  @override
  Creation3dProject getProject() => _project;

  @override
  List<SceneAsset> getAssetLibrary() => _assetLibrary;

  @override
  Creation3dProject addObjectFromAsset(SceneAsset asset) {
    final object = SceneObject3d(
      id: 'object-${_nextObjectId++}',
      name: asset.name,
      type: asset.type,
      lightIntensity: asset.type == SceneObjectType.light ? 1 : null,
      cameraFov: asset.type == SceneObjectType.camera ? 50 : null,
    );
    _project = _project.copyWith(objects: [..._project.objects, object]);
    return _project;
  }

  List<SceneObject3d> _mapObjects(
    String objectId,
    SceneObject3d Function(SceneObject3d) transform,
  ) {
    return _project.objects
        .map((object) => object.id == objectId ? transform(object) : object)
        .toList();
  }

  @override
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
  }) {
    _project = _project.copyWith(
      objects: _mapObjects(
        objectId,
        (object) => object.copyWith(
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
        ),
      ),
    );
    return _project;
  }

  @override
  Creation3dProject deleteObject(String objectId) {
    _project = _project.copyWith(
      objects: _project.objects
          .where((object) => object.id != objectId)
          .toList(),
    );
    return _project;
  }

  @override
  Creation3dProject duplicateObject(String objectId) {
    final original = _project.objects
        .where((object) => object.id == objectId)
        .toList();
    if (original.isEmpty) return _project;
    final source = original.first;
    final copy = SceneObject3d(
      id: 'object-${_nextObjectId++}',
      name: '${source.name} (copie)',
      type: source.type,
      position: source.position,
      rotation: source.rotation,
      scale: source.scale,
      colorValue: source.colorValue,
      material: source.material,
      lightIntensity: source.lightIntensity,
      cameraFov: source.cameraFov,
    );
    _project = _project.copyWith(objects: [..._project.objects, copy]);
    return _project;
  }

  @override
  Future<String> renderPreview() {
    return _renderService.renderPreview(
      sceneName: _project.name,
      objectCount: _project.objects.length,
      lightCount: _project.objects
          .where((object) => object.type == SceneObjectType.light)
          .length,
    );
  }
}
