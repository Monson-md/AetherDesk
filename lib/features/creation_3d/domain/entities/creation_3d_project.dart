import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';

/// A 3D scene: a name plus every [SceneObject3d] currently in the graph.
class Creation3dProject {
  const Creation3dProject({
    required this.id,
    required this.name,
    required this.objects,
  });

  factory Creation3dProject.initial() => const Creation3dProject(
    id: 'scene-1',
    name: 'Sans titre',
    objects: [
      SceneObject3d(id: 'object-1', name: 'Cube', type: SceneObjectType.cube),
      SceneObject3d(
        id: 'object-2',
        name: 'Lumière',
        type: SceneObjectType.light,
        position: Vector3(x: 2, y: 3, z: 2),
        colorValue: 0xFFFFF3B0,
        material: MaterialPreset.emissive,
        lightIntensity: 1,
      ),
      SceneObject3d(
        id: 'object-3',
        name: 'Caméra',
        type: SceneObjectType.camera,
        position: Vector3(y: 1, z: -5),
        cameraFov: 50,
      ),
    ],
  );

  final String id;
  final String name;
  final List<SceneObject3d> objects;

  Creation3dProject copyWith({String? name, List<SceneObject3d>? objects}) {
    return Creation3dProject(
      id: id,
      name: name ?? this.name,
      objects: objects ?? this.objects,
    );
  }
}
