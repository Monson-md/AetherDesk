import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';

/// One entry in the asset browser's catalog: a prefab that can be dropped
/// into the scene as a new [SceneObject3d].
class SceneAsset {
  const SceneAsset({required this.id, required this.name, required this.type});

  final String id;
  final String name;
  final SceneObjectType type;
}
