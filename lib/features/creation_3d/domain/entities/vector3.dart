/// A plain 3-component vector used for position, rotation and scale — kept
/// Flutter-free since it lives in `domain/`.
class Vector3 {
  const Vector3({this.x = 0, this.y = 0, this.z = 0});

  final double x;
  final double y;
  final double z;

  Vector3 copyWith({double? x, double? y, double? z}) {
    return Vector3(x: x ?? this.x, y: y ?? this.y, z: z ?? this.z);
  }
}
