/// The active drawing tool on the 2D canvas.
enum Canvas2dTool { select, brush, eraser, line, rectangle, ellipse, text }

/// The shape drawn by [Canvas2dTool.line], [Canvas2dTool.rectangle] and
/// [Canvas2dTool.ellipse].
enum Canvas2dShapeType { line, rectangle, ellipse }

/// Maps a shape-drawing [Canvas2dTool] to the [Canvas2dShapeType] it
/// produces, so callers don't need to track the shape kind as separate
/// state alongside the active tool.
extension Canvas2dToolShapeMapping on Canvas2dTool {
  Canvas2dShapeType? get asShapeType => switch (this) {
    Canvas2dTool.line => Canvas2dShapeType.line,
    Canvas2dTool.rectangle => Canvas2dShapeType.rectangle,
    Canvas2dTool.ellipse => Canvas2dShapeType.ellipse,
    _ => null,
  };
}
