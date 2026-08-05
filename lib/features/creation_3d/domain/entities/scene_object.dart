import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object_type.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';

/// A single object in the 3D scene graph: a mesh, a light or a camera,
/// depending on [type]. [lightIntensity] and [cameraFov] only apply when
/// [type] is respectively [SceneObjectType.light] and
/// [SceneObjectType.camera].
class SceneObject3d {
  const SceneObject3d({
    required this.id,
    required this.name,
    required this.type,
    this.position = const Vector3(),
    this.rotation = const Vector3(),
    this.scale = const Vector3(x: 1, y: 1, z: 1),
    this.colorValue = 0xFF8B5CF6,
    this.material = MaterialPreset.matte,
    this.isVisible = true,
    this.isLocked = false,
    this.lightIntensity,
    this.cameraFov,
  });

  final String id;
  final String name;
  final SceneObjectType type;
  final Vector3 position;
  final Vector3 rotation;
  final Vector3 scale;

  /// ARGB color value (`Color.toARGB32()`), kept as an int so this entity
  /// has no Flutter import.
  final int colorValue;
  final MaterialPreset material;
  final bool isVisible;
  final bool isLocked;
  final double? lightIntensity;
  final double? cameraFov;

  SceneObject3d copyWith({
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
    return SceneObject3d(
      id: id,
      name: name ?? this.name,
      type: type,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      colorValue: colorValue ?? this.colorValue,
      material: material ?? this.material,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      lightIntensity: lightIntensity ?? this.lightIntensity,
      cameraFov: cameraFov ?? this.cameraFov,
    );
  }
}
