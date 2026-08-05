import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_point.dart';
import 'package:aetherdesk/features/creation_2d/domain/entities/canvas_tool.dart';

/// Anything drawn onto a [Canvas2dLayer]: a freehand stroke, a shape or a
/// text label. Sealed so `presentation/` can exhaustively switch over the
/// concrete kind when painting.
sealed class Canvas2dElement {
  const Canvas2dElement({required this.id, required this.colorValue});

  final String id;

  /// ARGB color value (`Color.toARGB32()`), kept as an int so this entity
  /// has no Flutter import.
  final int colorValue;
}

/// A freehand brush or eraser stroke: an ordered list of points to be
/// rendered as a connected path.
class StrokeElement extends Canvas2dElement {
  const StrokeElement({
    required super.id,
    required super.colorValue,
    required this.strokeWidth,
    required this.points,
    this.isEraser = false,
  });

  final double strokeWidth;
  final List<CanvasPoint> points;
  final bool isEraser;
}

/// A line, rectangle or ellipse spanning from [start] to [end].
class ShapeElement extends Canvas2dElement {
  const ShapeElement({
    required super.id,
    required super.colorValue,
    required this.strokeWidth,
    required this.shapeType,
    required this.start,
    required this.end,
    this.isFilled = false,
  });

  final double strokeWidth;
  final Canvas2dShapeType shapeType;
  final CanvasPoint start;
  final CanvasPoint end;
  final bool isFilled;
}

/// A short text label placed at [position].
class TextElement2d extends Canvas2dElement {
  const TextElement2d({
    required super.id,
    required super.colorValue,
    required this.text,
    required this.position,
    required this.fontSize,
  });

  final String text;
  final CanvasPoint position;
  final double fontSize;
}
