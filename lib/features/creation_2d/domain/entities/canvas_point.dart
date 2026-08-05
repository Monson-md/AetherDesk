/// A single 2D coordinate on the drawing canvas. Kept as a plain value type
/// (rather than `dart:ui`'s `Offset`) so this entity has no Flutter import.
class CanvasPoint {
  const CanvasPoint(this.dx, this.dy);

  final double dx;
  final double dy;
}
